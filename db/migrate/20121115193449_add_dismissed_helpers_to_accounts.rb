class AddDismissedHelpersToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :dismissed_helpers, :string, :array => true, :default => '{}'
  end
end
