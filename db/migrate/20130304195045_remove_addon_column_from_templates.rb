class RemoveAddonColumnFromTemplates < ActiveRecord::Migration
  def up
    remove_column :templates, :addons
  end

  def down
    add_column :templates, :addons, :string, :array => true
  end
end
