class DeployedTemplateStateMessage < ActiveRecord::Migration
  def change
    add_column :deployed_templates, :state_messages, :string, :array => true, :default => '{}'
  end
end
