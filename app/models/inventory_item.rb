class InventoryItem < ApplicationRecord
  belongs_to :product
  
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :reserved_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :available_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :committed_quantity, numericality: { greater_than_or_equal_to: 0 }
  
  before_save :calculate_available_quantity
  
  def calculate_available_quantity
    self.available_quantity = quantity - reserved_quantity - committed_quantity
  end
  
  def in_stock?
    available_quantity > 0
  end
  
  def low_stock?(threshold = 5)
    available_quantity <= threshold
  end
  
  def reserve(quantity_to_reserve)
    return false if available_quantity < quantity_to_reserve
    
    transaction do
      update!(
        reserved_quantity: reserved_quantity + quantity_to_reserve,
        last_updated: Date.current
      )
      calculate_available_quantity
      save!
    end
    true
  rescue
    false
  end
  
  def release_reservation(quantity_to_release)
    return false if reserved_quantity < quantity_to_release
    
    transaction do
      update!(
        reserved_quantity: [reserved_quantity - quantity_to_release, 0].max,
        last_updated: Date.current
      )
      calculate_available_quantity
      save!
    end
    true
  rescue
    false
  end
  
  def commit(quantity_to_commit)
    return false if reserved_quantity < quantity_to_commit
    
    transaction do
      update!(
        reserved_quantity: reserved_quantity - quantity_to_commit,
        committed_quantity: committed_quantity + quantity_to_commit,
        last_updated: Date.current
      )
      calculate_available_quantity
      save!
    end
    true
  rescue
    false
  end
  
  def restock(quantity_to_add)
    transaction do
      update!(
        quantity: quantity + quantity_to_add,
        last_updated: Date.current
      )
      calculate_available_quantity
      save!
    end
    true
  rescue
    false
  end
  
  def consume(quantity_to_consume)
    return false if committed_quantity < quantity_to_consume
    
    transaction do
      update!(
        committed_quantity: committed_quantity - quantity_to_consume,
        quantity: quantity - quantity_to_consume,
        last_updated: Date.current
      )
      calculate_available_quantity
      save!
    end
    true
  rescue
    false
  end
end
