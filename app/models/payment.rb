class Payment < ApplicationRecord
  belongs_to :order
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, inclusion: { in: %w[credit_card debit_card paypal stripe apple_pay google_pay] }
  validates :status, inclusion: { in: %w[pending paid failed cancelled refunded partially_refunded] }
  
  def pending?
    status == 'pending'
  end
  
  def paid?
    status == 'paid'
  end
  
  def failed?
    status == 'failed'
  end
  
  def refundable?
    ['paid', 'partially_refunded'].include?(status)
  end
  
  def process_payment
    # Placeholder for actual payment processing
    # This would integrate with Stripe, PayPal, etc.
    
    # For now, simulate payment processing
    case payment_method
    when 'stripe'
      process_stripe_payment
    when 'paypal'
      process_paypal_payment
    else
      process_credit_card_payment
    end
  end
  
  private
  
  def process_stripe_payment
    # Actual Stripe integration would go here
    # For now, simulate successful payment
    update(status: 'paid', processed_at: Time.current)
  end
  
  def process_paypal_payment
    # Actual PayPal integration would go here
    # For now, simulate successful payment
    update(status: 'paid', processed_at: Time.current)
  end
  
  def process_credit_card_payment
    # Actual credit card processing would go here
    # For now, simulate successful payment
    update(status: 'paid', processed_at: Time.current)
  end
end
