class CreateTemplateDeployments < ActiveRecord::Migration
  def change
    create_table :template_deployments do |t|
      t.integer :user_id
      t.integer :template_id
      t.string  :web_url
      t.string  :git_url
      t.string  :app_name
      t.string  :state, :default => 'pending'
      t.timestamps
    end
  end
end
