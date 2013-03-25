class Template < ActiveRecord::Base
  DYNO_COST_IN_CENTS = 3500
  class IgataConfigError < Error; end
  @queue = :template
  attr_accessible :name, :account_id, :account, :post_deploy_processes, :developer_cost, :uri, :screenshots_attributes, :readme, :github_api_url, :github_organization
  attr_accessor :github_api_url, :github_organization

  # Associations
  belongs_to :account
  has_many :template_purchases
  has_many :template_demos
  has_many :purchasers, :through => :template_purchases, :source => :account
  has_many :screenshots
  has_many :addon_templates
  has_many :addons, :through => :addon_templates

  accepts_nested_attributes_for :screenshots

  # FriendlyId
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :scoped], :scope => :account

  # Serializers
  serialize :config_vars, Hash

  # Callbacks
  before_save :_add_config_var

  # Validations
  validates :name, :developer_cost, :uri, :presence => true
  validates :developer_cost, :numericality => true

  def self.perform(*args)
    self.send args.shift, *args
  end

  def self.clone_repo(id)
    template = Template.find(id)
    template.clone_repo
  end

  def self.pull_repo(id)
    template = Template.find(id)
    template.pull_repo
  end

  def developer_cost_in_cents
    developer_cost.nil? ? 0 : (developer_cost * 100).to_i
  end

  def stripe_plan_id
    "#{id} #{account.slug} #{slug}"
  end

  def pull_repo
    begin
      update_column(:state, 1026)
      case repo.pull
      when /Already up-to-date\./
        update_column(:state, 2040)
      else
        update_column(:state, 2001)
        self.git_commit_history += [repo.object('HEAD').sha]
        self.save(:validate => false)
      end
    rescue IgataConfigError
      update_column(:state, 7002)
    rescue Exception => e
      case e.message
      when /Could not read from remote repository./
        update_column(:state, 6030)
      when /Repository not found/
        update_column(:state, 6040)
      else
        update_column(:state, 7001)
      end

      puts e.message
      puts e.backtrace
    end
    update_column :last_git_action_at, DateTime.now
  end

  def clone_repo
    begin
      if Dir.exist? _repo_path
        FileUtils.rm_rf _repo_path
      end
      update_column(:state, 1025)

      if owner_and_repo = uri.match(/git@github.com:(?<owner>.+?)\/(?<repo>.+?)\.git$/)
        perform_github_clone(owner_and_repo)
      else
        Git.clone(self.uri, self.id.to_s, :path => GitDirectory)
      end

      filenames = Dir.entries(_repo_path)

      if readme_file = filenames.select{ |file| file =~ /^readme\.md$/i }.first
        process_readme_file readme_file
      end

      if igata_config_file = filenames.select{ |file| file =~ /^\.igata\.yml$/i }.first
        process_igata_config_file igata_config_file
      end

      update_column(:state, 2020)
      self.git_commit_history = [repo.object('HEAD').sha]
      create_or_update_stripe_plan
      self.save(:validate => false)
    rescue IgataConfigError
      update_column(:state, 5002)
    rescue Exception => e
      case e.message
      when /Could not read from remote repository./
        update_column(:state, 4030)
      when /Repository not found/
        update_column(:state, 4040)
      else
        update_column(:state, 5001)
      end

      puts e.message
      puts e.backtrace
    end
    update_column :last_git_action_at, DateTime.now
  end


  def has_clone_pending?
    # 1000s - Pending clone
    (1000...2000) === self.state
  end

  def can_clone?
    (4000...6000) === self.state
  end

  def has_pull_pending?
    (3000...4000) === self.state
  end

  def can_pull?
    (2000...3000) === self.state || (6000...8000) === self.state
  end

  def repo(git_logger = nil)
    @repo = Git.open(_repo_path, :log => git_logger)
  end

  def state_summary
    case state
    when 0...2000
      'Pending'
    when 2010...2020
      'Cloned'
    when 2000...3000
      'Up to date'
    when 3000...4000
      'No Changes'
    when 4000...6000
      'Clone Failed'
    else
      'Pull Failed'
    end
  end

  def state_message
    Settings['clone_status'][state]
  end

  def formatted_price
    "$#{'%.2f' % (monthly_cost_in_cents / 100.00)}".chomp('.00')
  end

  def dyno_count
    2
  end

  def monthly_cost_in_cents
    (((dyno_count - 1) * DYNO_COST_IN_CENTS + (addons.map(&:monthly_cost_in_cents)).sum) * 1.10 + developer_cost_in_cents).ceil
  end

  def dyno_cost_in_cents
    DYNO_COST_IN_CENTS
  end

  private

  def _add_config_var
    self.config_vars['igata'] = true
  end

  def create_or_update_stripe_plan
    begin
      stripe_plan = Stripe::Plan.retrieve stripe_plan_id
    rescue Stripe::InvalidRequestError
      stripe_plan = nil
    end

    if stripe_plan
      stripe_plan.amount = monthly_cost_in_cents
      stripe_plan.save
    else
      stripe_plan = Stripe::Plan.create :amount => monthly_cost_in_cents, :currency => 'usd',  :interval => 'month',
        :name => "Igata plan - #{account.username}: #{name}", :id => stripe_plan_id
    end
  end

  def process_readme_file(readme_file)
    if self.readme.blank?
      readme_content = File.read File.join(_repo_path, readme_file)
      update_column(:readme, readme_content)
    end
  end

  def perform_github_clone(owner_and_repo)
    access_token = self.account.github_identity.get_access_token
    response = access_token.get "/repos/#{owner_and_repo[:owner]}/#{owner_and_repo[:repo]}/tarball"

    File.open("#{_repo_path}.tar.gz", 'w:ASCII-8BIT') { |file| file.puts response.body }
    FileUtils.mkdir "#{_repo_path}_tmp"
    `tar -zxf #{_repo_path}.tar.gz -C #{_repo_path}_tmp`
    FileUtils.mv Dir.glob("#{_repo_path}_tmp/*").first, _repo_path
    FileUtils.rm_rf "#{_repo_path}_tmp"
    FileUtils.rm "#{_repo_path}.tar.gz"
    git = Git.init _repo_path
    git.add('.')
    git.commit_all("Repo clone #{Date.current}")
  end

  def process_igata_config_file(igata_file)
    begin
      igata_file_content = YAML.safe_load(File.open(File.join(_repo_path, igata_file)).read)
      self.addons.clear
      igata_file_content['addons'].each do |addon_name|
        self.addons << Addon.find_by_name!(addon_name)
      end
      self.post_deploy_processes = igata_file_content['post_deploy_processes']
      self.save
    rescue
      raise IgataConfigError
    end
  end

  def _repo_path
    @_repo_path ||= File.expand_path(self.id.to_s, GitDirectory)
  end
end
