class CombinePurchasedAndDeployedTemplate < ActiveRecord::Migration
  def up
    drop_table   :template_purchases
    add_column   :deployed_templates, :purchase_id, :string
    rename_table :deployed_templates, :template_purchases
  end

  def down
    remove_column :template_purchases, :purchase_id
    rename_table  :template_purchases, :deployed_templates

    create_table :template_purchases do |t|
      t.integer :template_id
      t.integer :account_id
      t.integer :purchase_id
      t.timestamps
    end
  end
end
