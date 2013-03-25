class DescriptionToReadme < ActiveRecord::Migration
  def up
    rename_column :templates, :description, :readme
  end

  def down
    rename_column :templates, :description, :readme
  end
end
