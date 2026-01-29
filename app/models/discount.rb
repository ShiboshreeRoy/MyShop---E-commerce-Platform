class Discount < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, inclusion: { in: %w[percentage fixed_amount free_shipping] }
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :usage_limit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :active, -> { where(active: true) }
  scope :applicable, -> { active.where('expires_at IS NULL OR expires_at > ?', Time.current) }
  
  def percentage?
    discount_type == 'percentage'
  end
  
  def fixed_amount?
    discount_type == 'fixed_amount'
  end
  
  def free_shipping?
    discount_type == 'free_shipping'
  end
  
  def expired?
    expires_at.present? && expires_at < Time.current
  end
  
  def expired_or_inactive?
    !active? || expired?
  end
  
  def usage_remaining
    return Float::INFINITY if usage_limit.nil?
    usage_limit - used_count
  end
  
  def available?
    active? && !expired? && usage_remaining > 0
  end
  
  def apply_to_amount(amount)
    return 0 if expired_or_inactive? || usage_remaining <= 0
    
    case discount_type
    when 'percentage'
      (amount * (value / 100)).round(2)
    when 'fixed_amount'
      [value, amount].min
    else
      0
    end
  end
end
