class RenameIdentitiesToEasyAuthIdentities < ActiveRecord::Migration
  def up
    rename_table :identities, :easy_auth_identities
    update = "UPDATE easy_auth_identities set type = 'EasyAuth::Identities::Password' where type = 'PasswordIdentity'"
    execute update
  end

  def down
    rename_table :easy_auth_identities, :identities
  end
end
