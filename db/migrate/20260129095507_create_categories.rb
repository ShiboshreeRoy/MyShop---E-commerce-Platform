class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.references :parent, null: true, foreign_key: { to_table: :categories }
      t.string :slug
      t.string :meta_title
      t.text :meta_description
      t.integer :position, default: 0
      t.boolean :active, default: true
      
      t.timestamps
    end
    
    add_index :categories, :slug
    add_index :categories, :position
    add_index :categories, :active
  end
end
