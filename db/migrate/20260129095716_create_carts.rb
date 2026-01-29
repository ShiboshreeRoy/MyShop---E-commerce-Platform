class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_id
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0
      t.decimal :tax_total, precision: 10, scale: 2, default: 0.0
      t.decimal :shipping_total, precision: 10, scale: 2, default: 0.0
      t.decimal :total, precision: 10, scale: 2, default: 0.0
      t.integer :item_count, default: 0
      t.json :extra_data # for storing additional cart information
      
      t.timestamps
    end
    
    add_index :carts, :session_id
  end
end
