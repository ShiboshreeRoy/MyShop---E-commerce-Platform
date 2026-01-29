class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :theme, default: 'default'
      t.string :status, default: 'active'
      t.string :slug
      t.text :custom_css
      t.text :custom_js
      t.boolean :published, default: false
      t.string :logo
      t.string :favicon
      t.string :primary_color, default: '#4f46e5'
      t.string :secondary_color, default: '#f9fafb'

      t.timestamps
    end
    
    add_index :stores, :slug, unique: true
    add_index :stores, :status
  end
end
