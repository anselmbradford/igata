require 'easy_auth/models/identities/oauth2/github'

module EasyAuth::Models::Identities::Oauth2::Github
  def oauth2_scope
    'user,repo'
  end
end
