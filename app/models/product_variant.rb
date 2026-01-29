class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :cart_items
  has_many :order_items
  has_one_attached :image
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { case_sensitive: false }, allow_blank: true
  
  def in_stock?
    stock_quantity > 0
  end
  
  def display_name
    "#{product.name} - #{name}"
  end
end
