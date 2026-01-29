class ShippingCalculator
  def initialize(order, shipping_address = {})
    @order = order
    @shipping_address = shipping_address
  end

  def calculate_shipping_rates
    # Calculate shipping rates based on order contents and destination
    applicable_rates = ShippingRate.active
    
    # Filter by destination
    applicable_rates = applicable_rates.for_location(
      @shipping_address[:country],
      @shipping_address[:state],
      @shipping_address[:zip_code]
    )
    
    # Calculate total weight and price of order
    total_weight = calculate_order_weight
    total_price = @order.subtotal

    # Filter by weight and price ranges
    applicable_rates.select do |rate|
      rate.applicable_to_weight?(total_weight) && 
      rate.applicable_to_price?(total_price)
    end
  end

  def find_cheapest_rate
    rates = calculate_shipping_rates
    rates.min_by(&:rate)
  end

  def calculate_order_weight
    @order.order_items.sum do |item|
      # Assuming products have a weight attribute
      (item.product_variant.product.weight.to_f || 0) * item.quantity
    end
  end

  def apply_shipping_to_order(shipping_rate_id)
    shipping_rate = ShippingRate.find(shipping_rate_id)
    
    # Verify the rate is applicable
    return false unless shipping_rate.active?
    total_weight = calculate_order_weight
    total_price = @order.subtotal
    
    return false unless shipping_rate.applicable_to_weight?(total_weight) &&
                        shipping_rate.applicable_to_price?(total_price) &&
                        shipping_rate.applicable_to_location?(
                          @shipping_address[:country],
                          @shipping_address[:state],
                          @shipping_address[:zip_code]
                        )

    # Update the order with shipping cost
    @order.update!(
      shipping_total: shipping_rate.rate,
      shipping_address: @shipping_address
    )
    
    true
  end

  # Calculate flat rate if no specific rates are found
  def calculate_flat_rate(flat_rate = 5.00)
    # If no specific shipping rates apply, use a flat rate
    { 
      id: 'flat_rate',
      carrier: 'Standard Shipping',
      service_type: 'ground',
      rate: flat_rate,
      delivery_days: 5..7,
      estimated_delivery: Date.current + 7.days
    }
  end
end