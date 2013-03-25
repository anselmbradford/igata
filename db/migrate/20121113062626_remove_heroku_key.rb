class RemoveHerokuKey < ActiveRecord::Migration
  def up
    remove_column :accounts, :api_key
  end

  def down
    add_column :accounts, :api_key, :string
  end
end
