class TemplatePurchasesController < AuthenticatedController
  before_filter :_redirect_if_no_active_card, :only => [:can_purchase]
  skip_before_filter :attempt_to_authenticate
  respond_to :json, :only => [:create, :can_purchase, :destroy]

  def index
    @templates = current_account.purchased_templates
  end

  def create
    account = Account.find params[:username]
    template = account.templates.find params[:id]
    @template_purchase = current_account.template_purchases.build(:template_id => template.id)

    if @template_purchase.save
      Resque.enqueue(TemplatePurchase, @template_purchase.id)
    end

    respond_with @template_purchase, :location => nil
  end

  def can_purchase
    head 200
  end

  def destroy
    @template_purchase = current_account.template_purchases.find params[:id]
    unless @template_purchase.state == 'failed'
      @template_purchase.heroku_destroy_app
    end
    @template_purchase.destroy
    respond_with :success => true
  end

  private

  def _redirect_if_no_active_card
    account = Account.find_by_slug!(params[:username])
    template = account.templates.find_by_slug!(params[:id])
    session[:requested_path] = template_path(account, template, :anchor => 'purchase')
    if account_not_signed_in?
      flash[:notice] = 'Please sign up or sign in to continue. Thank you'
      head 401, :location => sign_up_url
    elsif current_account.does_not_have_active_card?
      flash[:notice] = I18n.translate :no_active_card
      head 402, :location => edit_account_url(:anchor => 'add-credit-card')
    end
  end
end
