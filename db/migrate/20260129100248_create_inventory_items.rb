class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.integer :reserved_quantity, default: 0
      t.integer :available_quantity, default: 0
      t.integer :committed_quantity, default: 0 # Quantity that has been committed to orders
      t.string :location # Warehouse location
      t.date :last_updated
      
      t.timestamps
    end
    
    add_index :inventory_items, :available_quantity
  end
end
