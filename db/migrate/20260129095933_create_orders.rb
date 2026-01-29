class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :status, default: 'pending'
      t.string :order_number
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.decimal :tax_total, precision: 10, scale: 2, default: 0.0
      t.decimal :shipping_total, precision: 10, scale: 2, default: 0.0
      t.decimal :discount_total, precision: 10, scale: 2, default: 0.0
      t.text :special_instructions
      t.json :shipping_address
      t.json :billing_address
      t.string :payment_status, default: 'pending'
      t.string :fulfillment_status, default: 'pending'
      t.references :discount, null: true, foreign_key: true
      
      t.timestamps
    end
    
    add_index :orders, :order_number, unique: true
    add_index :orders, :status
    add_index :orders, :payment_status
  end
end
