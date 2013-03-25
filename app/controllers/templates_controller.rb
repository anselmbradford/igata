class TemplatesController < ApplicationController
  def show
    @account  = Account.find params[:username]
    @template = @account.templates.find params[:id]
    @demos = current_account.present? ? current_account.template_demos.where(:template_id => @template.id) : []
    @purchases = current_account.present? ? current_account.template_purchases.where(:template_id => @template.id) : []
  end
end
