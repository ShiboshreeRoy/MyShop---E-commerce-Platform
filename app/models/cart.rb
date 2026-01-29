class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  has_many :orders
  
  validates :item_count, numericality: { greater_than_or_equal_to: 0 }
  
  def add_item(product_variant, quantity = 1)
    cart_item = cart_items.find_or_initialize_by(product_variant: product_variant)
    cart_item.update(quantity: cart_item.quantity + quantity)
    update_totals
  end
  
  def remove_item(product_variant)
    cart_item = cart_items.find_by(product_variant: product_variant)
    cart_item&.destroy
    update_totals
  end
  
  def update_item_quantity(product_variant, quantity)
    cart_item = cart_items.find_by(product_variant: product_variant)
    if quantity <= 0
      cart_item&.destroy
    else
      cart_item&.update(quantity: quantity)
    end
    update_totals
  end
  
  def total_items
    cart_items.sum(:quantity)
  end
  
  def total_price
    cart_items.sum("quantity * unit_price")
  end
  
  def update_totals
    self.item_count = total_items
    self.subtotal = total_price
    self.total = subtotal + tax_total + shipping_total
    save!
  end
  
  def clear!
    cart_items.destroy_all
    update(item_count: 0, subtotal: 0, total: 0)
  end
end
