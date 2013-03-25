class ProfilesController < ApplicationController
  def show
    @account = Account.find params[:username]
    @templates = @account.templates
  end
end
