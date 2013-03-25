class RenameUsernameToUidOnIdentities < ActiveRecord::Migration
  def up
    rename_column :identities, :username, :uid
  end

  def down
    rename_column :identities, :uid, :username
  end
end
