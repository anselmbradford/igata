class ConvertTemplatePriceToCurrency < ActiveRecord::Migration
  def up
    change_column :templates, :price, :money
  end

  def down
  end
end
