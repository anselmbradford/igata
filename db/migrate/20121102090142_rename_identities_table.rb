class RenameIdentitiesTable < ActiveRecord::Migration
  def change
    rename_table :easy_auth_identities, :identities
  end
end
