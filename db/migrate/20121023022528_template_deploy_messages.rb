class TemplateDeployMessages < ActiveRecord::Migration
  def change
    add_column :template_deployments, :error_message, :text
    add_column :template_deployments, :error_backtrace, :text
  end
end
