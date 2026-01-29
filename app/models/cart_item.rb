class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_variant
  has_one :product, through: :product_variant
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  before_save :calculate_total_price
  
  def calculate_total_price
    self.total_price = unit_price * quantity
  end
  
  def subtotal
    unit_price * quantity
  end
end
