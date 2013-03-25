class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  private

  def after_successful_sign_in_url
    main_app.root_path
  end

  def after_failed_sign_in_default
    flash.now[:error] = I18n.t('easy_auth.sessions.create.error')
    render :new
  end

  def after_failed_sign_in_with_oauth2
    redirect_to new_template_path, :notice => 'Could not authenticate with Github'
  end
end
