class TemplatePurchase < ActiveRecord::Base
  include HerokuDeploy
  @queue = :purchased_template

  attr_accessible :account, :template, :template_id

  # Associations
  belongs_to :account
  belongs_to :template

  # Validations
  validate :purchase

  def purchase
    unless self.purchase_id = account.purchase_template(template)
      errors.add(:base, 'Purchase failed')
    end
  end

  def self.perform(id)
    deployed_template = find(id)
    deployed_template.deploy
  end

  def push_to_column(name, value)
    name = name.to_s
    raise ActiveRecordError, "#{name} is marked as readonly" if self.class.readonly_attributes.include?(name)
    send("#{name}=", self.send(name).push(value))
    send("#{name}_will_change!")
    save(:validate => false)
  end

  def deploy
    begin
      heroku_deploy
      update_column(:state, 'deployed')
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
      push_to_column(:state_messages, 'Deploy failed, reimbursing')
      update_column(:state, 'failed')
      update_column(:error_message, e.message)
      update_column(:error_backtrace, e.backtrace)
      Stripe::Charge.retrieve(purchase_id).refund
      if app_name
        heroku_destroy_app
        self.app_name = nil
      end
    ensure
      if app_name
        heroku_remove_igata_collaborator
      end
    end
  end

  private

  def _push_repo
    remote = template.repo.add_remote(app_name, git_url)
    template.repo.lib.send(:command, 'push', [remote, 'master']) do |pipe|
      buff = ''
      while char = pipe.read(1)
        if char == "\n"
          push_to_column(:state_messages, buff)
          buff = ''
        else
          buff << char
        end
      end
    end
    template.repo.lib.send(:command, 'remote', ['rm', app_name])
  end
end
