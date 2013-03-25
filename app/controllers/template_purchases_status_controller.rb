class TemplatePurchasesStatusController < AuthenticatedController
  respond_to :json

  def show
    respond_with current_account.template_purchases.find(params[:id])
  end
end
