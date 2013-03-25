class TemplateDemosController < AuthenticatedController
  before_filter :_redirect_unsigned_users_to_signup, :only => [:can_demo]
  skip_before_filter :attempt_to_authenticate
  respond_to :json, :only => [:create, :can_demo, :destroy]

  def create
    account = Account.find_by_slug! params[:username]
    template = account.templates.find_by_slug! params[:id]
    @template_demo = current_account.template_demos.build(:template_id => template.id)

    if @template_demo.save
      Resque.enqueue(TemplateDemo, :deploy, @template_demo.id)
    end

    respond_with @template_demo, :location => nil
  end

  def destroy
    @template_demo = current_account.template_demos.find params[:id]

    @template_demo.destroy()

    respond_with :success => true
  end

  def can_demo
    head 200
  end

  private

  def _redirect_unsigned_users_to_signup
    account = Account.find_by_slug!(params[:username])
    template = account.templates.find_by_slug!(params[:id])
    session[:requested_path] = template_path(account, template, :anchor => 'demo')
    if account_not_signed_in?
      flash[:notice] = 'Please sign up or sign in to continue. Thank you.'
      head 401, :location => sign_up_url
    end
  end
end
