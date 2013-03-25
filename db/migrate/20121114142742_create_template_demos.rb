class CreateTemplateDemos < ActiveRecord::Migration
  def change
    create_table :template_demos do |t|
      t.references :account
      t.references :template
      t.string :web_url
      t.string :git_url
      t.string :app_name
      t.string :state, :default => 'pending'
      t.text :error_message
      t.text :error_backtrace
      t.string :state_messages, :array => true, :default => '{}'
      t.datetime :valid_until

      t.timestamps
    end
    add_index :template_demos, :account_id
    add_index :template_demos, :template_id
  end
end
