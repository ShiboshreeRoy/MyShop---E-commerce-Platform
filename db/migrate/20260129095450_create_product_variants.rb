class CreateProductVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :product_variants do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock_quantity, default: 0
      t.string :sku
      t.boolean :available, default: true
      t.text :option_values # JSON field to store variant options (size, color, etc.)
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :product_variants, :sku, unique: true
  end
end
