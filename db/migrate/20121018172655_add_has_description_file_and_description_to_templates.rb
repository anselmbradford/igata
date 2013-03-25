class AddHasDescriptionFileAndDescriptionToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :description, :text, :default => ''
  end
end
