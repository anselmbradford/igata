class CreateAddons < ActiveRecord::Migration
  def up
    create_table :addons do |t|
      t.string  :name, :null => false, :unique => true
      t.string  :description
      t.string  :url
      t.boolean :beta
      t.string  :state
      t.integer :cents, :null => false
      t.string  :price_units, :null => false
      t.boolean :attachable
      t.string  :slug
      t.boolean :consumes_dyno_hours
      t.string  :plan_description
      t.string  :group_description
      t.boolean :selective

      t.timestamps
    end

    add_index :addons, :name, :unique => true
  end

  def down
    drop_table :addons
  end
end
