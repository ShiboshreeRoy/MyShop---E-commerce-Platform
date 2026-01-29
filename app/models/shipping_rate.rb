class ShippingRate < ApplicationRecord
  validates :carrier, presence: true
  validates :service_type, presence: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :min_weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_weight, numericality: { greater_than: :min_weight }, allow_nil: true
  validates :min_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_price, numericality: { greater_than: :min_price }, allow_nil: true
  
  scope :active, -> { where(active: true) }
  scope :for_carrier, ->(carrier) { where(carrier: carrier) }
  scope :for_service_type, ->(service_type) { where(service_type: service_type) }
  scope :for_location, ->(country, state = nil, zip_code = nil) do
    query = where(country: country)
    query = query.where(state: state) if state.present?
    query = query.where(zip_code: zip_code) if zip_code.present?
    query
  end
  
  def applicable_to_weight?(weight)
    return true if min_weight.nil? && max_weight.nil?
    return weight >= min_weight if max_weight.nil?
    return weight <= max_weight if min_weight.nil?
    min_weight <= weight && weight <= max_weight
  end
  
  def applicable_to_price?(price)
    return true if min_price.nil? && max_price.nil?
    return price >= min_price if max_price.nil?
    return price <= max_price if min_price.nil?
    min_price <= price && price <= max_price
  end
  
  def applicable_to_location?(country, state = nil, zip_code = nil)
    return false unless self.country == country
    return false if state.present? && self.state.present? && self.state != state
    return false if zip_code.present? && self.zip_code.present? && self.zip_code != zip_code
    true
  end
  
  def estimated_delivery_date
    return nil unless delivery_days.present?
    Date.current + delivery_days.days
  end
end
