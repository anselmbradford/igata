class RenameTemplateDeployment < ActiveRecord::Migration
  def change
    rename_table :template_deployments, :deployed_templates
  end
end
