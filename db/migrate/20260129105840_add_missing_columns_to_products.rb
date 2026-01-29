class AddMissingColumnsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :cost_per_item, :decimal, precision: 10, scale: 2
    add_column :products, :barcode, :string
    add_column :products, :taxable, :boolean, default: true
    add_column :products, :featured, :boolean, default: false
    add_column :products, :low_stock_threshold, :integer, default: 5
    add_column :products, :allow_out_of_stock_purchases, :boolean, default: false
    add_column :products, :material, :string
    add_column :products, :care_instructions, :text
    add_column :products, :dimensions_length, :decimal, precision: 10, scale: 2
    add_column :products, :dimensions_width, :decimal, precision: 10, scale: 2
    add_column :products, :dimensions_height, :decimal, precision: 10, scale: 2
  end
end
