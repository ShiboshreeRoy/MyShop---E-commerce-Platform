class CreateDiscounts < ActiveRecord::Migration[8.1]
  def change
    create_table :discounts do |t|
      t.string :code
      t.string :discount_type, default: 'percentage' # percentage, fixed_amount, free_shipping
      t.decimal :value, precision: 10, scale: 2
      t.decimal :minimum_order_value, precision: 10, scale: 2, default: 0.0
      t.integer :usage_limit
      t.integer :used_count, default: 0
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :active, default: true
      t.references :user, null: true, foreign_key: true # for user-specific discounts
      t.string :description
      
      t.timestamps
    end
    
    add_index :discounts, :code, unique: true
    add_index :discounts, :active
  end
end
