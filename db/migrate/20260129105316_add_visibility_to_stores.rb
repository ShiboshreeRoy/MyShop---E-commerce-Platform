class AddVisibilityToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :visibility, :string, default: 'public'
  end
end
