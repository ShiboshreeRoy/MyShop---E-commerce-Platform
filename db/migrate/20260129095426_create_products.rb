class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.references :store, null: false, foreign_key: true
      t.string :sku
      t.string :status, default: 'active'
      t.integer :stock_quantity, default: 0
      t.boolean :available, default: true
      t.text :short_description
      t.string :meta_title
      t.text :meta_description
      t.string :tags
      t.string :weight
      t.string :dimensions
      t.string :condition, default: 'new'
      
      t.timestamps
    end
    
    add_index :products, :sku, unique: true
    add_index :products, :status
    add_index :products, :available
  end
end
