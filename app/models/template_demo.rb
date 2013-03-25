class TemplateDemo < ActiveRecord::Base
  include HerokuDeploy
  @queue = :template_demo

  attr_accessible :account, :template, :template_id

  # Associations
  belongs_to :account

  belongs_to :template

  def self.perform(*args)
    self.send args.shift, *args
  end

  def push_to_column(name, value)
    name = name.to_s
    raise ActiveRecordError, "#{name} is marked as readonly" if self.class.readonly_attributes.include?(name)
    send("#{name}=", self.send(name).push(value))
    send("#{name}_will_change!")
    save(:validate => false)
  end

  def self.deploy(id)
    template_demo = self.find id
    template_demo.deploy
  end

  def self.destroy_app(id)
    template_demo = self.find id
    template_demo.destroy_app
  end

  def destroy_app
    update_column(:state, 'expired')
    heroku_destroy_app
  end

  def deploy
    begin
      heroku_deploy
      update_column(:state, 'deployed')
      Resque.enqueue_in(5.minutes, self.class, :destroy_app, self.id)
      update_column(:valid_until, 5.minutes.from_now)
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
      push_to_column(:state_messages, 'Deploy failed')
      update_column(:state, 'failed')
      update_column(:error_message, e.message)
      update_column(:error_backtrace, e.backtrace)
      if app_name
        heroku_destroy_app
        self.app_name = nil
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
