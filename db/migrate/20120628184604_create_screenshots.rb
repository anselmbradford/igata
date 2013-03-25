class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.references :template
      t.string :image

      t.timestamps
    end
    add_index :screenshots, :template_id
  end
end
