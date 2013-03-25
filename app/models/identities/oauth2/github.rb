class Identities::Oauth2::Github < Identities::Oauth2::Base
  extend EasyAuth::Models::Identities::Oauth2::Github

  def self.new_session(controller)
    controller.session[:requested_path] = "#{controller.request.env['HTTP_REFERER']}#choose-source/github"
    super
  end
end
