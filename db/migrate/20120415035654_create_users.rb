class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :api_key
      t.string :name
      t.string :stripe_id
      t.string :session_token

      t.timestamps
    end

    add_index :users, :session_token
  end
end
