class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string  :name
      t.integer :user_id
      t.decimal :price
      t.string  :uri
      t.string  :state, :default => 'pending'
      t.text    :config_vars
      t.string  :post_deploy_processes, :array => true, :default => '{}'
      t.string  :addons, :array => true, :default => '{}'

      t.timestamps
    end
  end
end
