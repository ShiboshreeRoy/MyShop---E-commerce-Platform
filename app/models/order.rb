
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :store
  belongs_to :discount, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  belongs_to :cart, optional: true
  
  validates :status, inclusion: { in: %w[pending paid shipped delivered cancelled refunded] }
  validates :payment_status, inclusion: { in: %w[pending paid failed refunded partially_refunded] }
  validates :fulfillment_status, inclusion: { in: %w[pending fulfilled partial shipped delivered cancelled] }
  
  before_validation :generate_order_number, on: :create
  
  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{id.to_s.rjust(6, '0')}" if id.present?
  end
  
  def pending_payment?
    payment_status == 'pending'
  end
  
  def paid?
    payment_status == 'paid'
  end
  
  def cancelled?
    status == 'cancelled'
  end
  
  def completed?
    status == 'delivered'
  end
  
  def total_items
    order_items.sum(:quantity)
  end
  
  def subtotal
    order_items.sum(&:total_price)
  end
  
  def total
    subtotal + shipping_total - discount_total
  end
  
  def can_cancel?
    ['pending', 'paid'].include?(status)
  end
  
  def can_refund?
    ['delivered', 'shipped'].include?(status)
  end
  
  def process_inventory
    order_items.each do |item|
      inventory_item = InventoryItem.find_or_create_by(product: item.product_variant.product)
      # Reserve the quantity when order is placed
      inventory_item.reserve(item.quantity)
    end
  end
  
  def fulfill_order
    order_items.each do |item|
      inventory_item = InventoryItem.find_by(product: item.product_variant.product)
      next unless inventory_item
      
      # Commit the reservation when shipping
      inventory_item.commit(item.quantity)
    end
    
    update(fulfillment_status: 'fulfilled')
  end
  
  def cancel_inventory_reservation
    order_items.each do |item|
      inventory_item = InventoryItem.find_by(product: item.product_variant.product)
      next unless inventory_item
      
      # Release the reservation when order is cancelled
      inventory_item.release_reservation(item.quantity)
    end
  end
  
  def return_items
    order_items.each do |item|
      inventory_item = InventoryItem.find_by(product: item.product_variant.product)
      next unless inventory_item
      
      # Add the items back to inventory when returned
      inventory_item.restock(item.quantity)
    end
  end
end
