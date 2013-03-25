class CreateAddonTemplates < ActiveRecord::Migration
  def change
    create_table :addon_templates do |t|
      t.references :addon
      t.references :template

      t.timestamps
    end
    add_index :addon_templates, :addon_id
    add_index :addon_templates, :template_id
  end
end
