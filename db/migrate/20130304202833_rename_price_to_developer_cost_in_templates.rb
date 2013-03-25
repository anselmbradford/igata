class RenamePriceToDeveloperCostInTemplates < ActiveRecord::Migration
  def up
    rename_column :templates, :price, :developer_cost
  end

  def down
    rename_column :templates, :developer_cost, :price
  end
end
