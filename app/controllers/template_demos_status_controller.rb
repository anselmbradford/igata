class TemplateDemosStatusController < AuthenticatedController
  respond_to :json

  def show
    respond_with current_account.template_demos.find(params[:id])
  end
end
