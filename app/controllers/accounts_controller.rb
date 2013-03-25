class AccountsController < AuthenticatedController
  skip_before_filter :attempt_to_authenticate, :only => [:new, :create]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])

    if @account.save
      @account.reload
      session[:identity_id] = @account.password_identities.first.id
      if session[:requested_path].nil?
        redirect_to dashboard_path
      elsif session[:requested_path].match /#demo/
        redirect_to session[:requested_path]
      else session[:requested_path].match /#purchase/
        flash[:notice] = I18n.translate :no_active_card
        redirect_to edit_account_url(:anchor => 'add-credit-card')
      end
    else
      render :new
    end
  end

  def update
    if current_account.update_attributes(params[:account])
      redirect_to (session[:requested_path] || edit_account_path), :notice => 'Your account has been updated.'
    else
      render :edit
    end
  end
end
