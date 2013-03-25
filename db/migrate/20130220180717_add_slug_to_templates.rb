class AddSlugToTemplates < ActiveRecord::Migration
  def up
    add_column :templates, :slug, :string
    add_index :templates, :slug
    Template.find_each(&:save)
  end

  def down
    remove_index  :templates, :slug
    remove_column :templates, :slug
  end
end
