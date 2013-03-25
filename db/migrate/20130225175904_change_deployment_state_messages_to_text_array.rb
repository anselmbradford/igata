class ChangeDeploymentStateMessagesToTextArray < ActiveRecord::Migration
  def up
    remove_column :template_demos,     :state_messages
    add_column    :template_demos,     :state_messages, :text, :array => true, :default => []
    remove_column :template_purchases, :state_messages
    add_column    :template_purchases, :state_messages, :text, :array => true, :default => []
  end

  def down
    remove_column :template_demos,     :state_messages
    add_column    :template_demos,     :state_messages, :string, :array => true, :default => []
    remove_column :template_purchases, :state_messages
    add_column    :template_purchases, :state_messages, :string, :array => true, :default => []
  end
end
