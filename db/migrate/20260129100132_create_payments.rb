class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :payment_method # e.g., 'credit_card', 'paypal', 'stripe'
      t.string :transaction_id
      t.string :status, default: 'pending'
      t.string :gateway_response_code
      t.text :gateway_response_message
      t.json :gateway_metadata
      t.datetime :processed_at
      
      t.timestamps
    end
    
    add_index :payments, :transaction_id
    add_index :payments, :status
  end
end
