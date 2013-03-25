class RenameUserToAccount < ActiveRecord::Migration
  def up
    rename_table :users, :accounts
    rename_column :deployed_templates, :user_id, :account_id
    rename_column :template_purchases, :user_id, :account_id
    rename_column :templates, :user_id, :account_id

    ActiveRecord::Base.connection.execute <<-SQL
UPDATE identities
SET account_type = 'Account'
SQL
  end

  def down
    rename_table :accounts, :users
    rename_column :deployed_templates, :account_id, :user_id
    rename_column :template_purchases, :account_id, :user_id
    rename_column :templates, :account_id, :user_id
    ActiveRecord::Base.connection.execute <<-SQL
UPDATE identities
SET account_type = 'User'
SQL
  end
end
