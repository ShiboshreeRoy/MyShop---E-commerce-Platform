class CreateShippingRates < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_rates do |t|
      t.string :carrier # e.g., 'UPS', 'FedEx', 'DHL', 'USPS'
      t.string :service_type # e.g., 'ground', 'express', 'overnight'
      t.decimal :rate, precision: 10, scale: 2
      t.decimal :min_weight, precision: 10, scale: 2, default: 0.0
      t.decimal :max_weight, precision: 10, scale: 2
      t.decimal :min_price, precision: 10, scale: 2, default: 0.0
      t.decimal :max_price, precision: 10, scale: 2
      t.string :country, default: 'US'
      t.string :state
      t.string :zip_code
      t.boolean :active, default: true
      t.integer :delivery_days
      t.string :currency, default: 'USD'
      
      t.timestamps
    end
    
    add_index :shipping_rates, :carrier
    add_index :shipping_rates, :active
    add_index :shipping_rates, :service_type
  end
end
