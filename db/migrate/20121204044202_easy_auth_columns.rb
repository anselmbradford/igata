class EasyAuthColumns < ActiveRecord::Migration
  def up
    remove_column :accounts, :session_token
    rename_column :identities, :remember_token, :remember_token_digest
    rename_column :identities, :reset_token, :reset_token_digest
  end

  def down
    add_column :accounts, :session_token, :string
    rename_column :identities, :remember_token_digest, :remember_token
    rename_column :identities, :reset_token_digest, :reset_token
  end
end
