class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, limit: 1 # 1-5 stars
      t.string :title
      t.text :content
      t.string :status, default: 'pending'
      t.boolean :verified_purchase, default: false
      t.datetime :approved_at
      
      t.timestamps
    end
    
    add_index :reviews, :rating
    add_index :reviews, :status
  end
end
