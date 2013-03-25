module HerokuDeploy
  def heroku_client
    @heroku_client ||= Heroku::API.new(:api_key => Settings['heroku']['api_key'])
  end

  def heroku_deploy
    update_column(:state, 'deploying')
    push_to_column(:state_messages, 'Provisioning server')
    response = heroku_client.post_app(:stack => :cedar)
    push_to_column(:state_messages, 'Setting meta-data')
    update_column(:app_name, response.body['name'])
    update_column(:web_url, response.body['web_url'])
    update_column(:git_url, response.body['git_url'])
    push_to_column(:state_messages, 'Setting config variables')
    heroku_client.put_config_vars(app_name, template.config_vars)
    push_to_column(:state_messages, 'Setting add-ons')
    heroku_addons
    push_to_column(:state_messages, 'Deploying application')
    _push_repo
    push_to_column(:state_messages, 'Running post-deploy processes')
    heroku_processes
    heroku_client.post_ps_restart(app_name)
  end

  def heroku_destroy_app
    heroku_client.delete_app(app_name) rescue nil
  end

  def heroku_remove_igata_collaborator
    heroku_client.delete_collaborator(app_name, Settings['heroku']['username']) rescue nil
  end

  def heroku_addons
    if template.addons.present?
      template.addons.each do |addon|
        heroku_client.post_addon(app_name, addon)
      end
    end
  end

  def heroku_processes
    if template.post_deploy_processes.present?
      template.post_deploy_processes.each do |process|
        response = heroku_client.post_ps(app_name, process, { :attach => true, :ps_env => { "TERM" => ENV["TERM"] } } )
        rendezvous = Heroku::Client::Rendezvous.new(
          :rendezvous_url => response.body['rendezvous_url'],
          :connect_timeout => (ENV["HEROKU_CONNECT_TIMEOUT"] || 120).to_i,
          :activity_timeout => nil,
          :output => output_logger)
        rendezvous.start
      end
    end
  end

  def output_logger
    @output_logger ||= HerokuLogger.new self
  end

  class HerokuLogger
    def initialize(template_deploy)
      @template = template_deploy
    end

    def write(message)
      @template.push_to_column(:state_messages, message)
    end

    def isatty
      false
    end
  end
end
