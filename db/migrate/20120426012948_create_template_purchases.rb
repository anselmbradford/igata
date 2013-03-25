class CreateTemplatePurchases < ActiveRecord::Migration
  def change
    create_table :template_purchases do |t|
      t.integer :template_id
      t.integer :user_id
      t.integer :purchase_id
      t.timestamps
    end
  end
end
