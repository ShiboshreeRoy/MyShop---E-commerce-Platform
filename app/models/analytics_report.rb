class AnalyticsReport < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :store, optional: true
  
  validates :name, presence: true
  validates :report_type, presence: true, inclusion: { in: %w[sales traffic customer inventory conversion abandoned_cart] }
  validates :status, inclusion: { in: %w[processing completed failed queued scheduled] }
  
  scope :completed, -> { where(status: 'completed') }
  scope :by_type, ->(report_type) { where(report_type: report_type) }
  scope :for_store, ->(store_id) { where(store_id: store_id) }
  scope :recent, -> { order(created_at: :desc) }
  scope :scheduled, -> { where.not(scheduled_at: nil) }
  
  def completed?
    status == 'completed'
  end
  
  def processing?
    status == 'processing'
  end
  
  def generate_sales_report(start_date, end_date)
    # Generate sales report data
    orders = Order.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      status: 'delivered'
    )
    
    {
      total_sales: orders.sum(:total),
      total_orders: orders.count,
      avg_order_value: orders.average(:total)&.round(2),
      top_products: get_top_products(orders, 5),
      revenue_by_date: calculate_revenue_by_date(orders, start_date, end_date)
    }
  end
  
  def generate_traffic_report(start_date, end_date)
    # Generate traffic report data
    # In a real implementation, this would connect to analytics API
    # For now, we'll return placeholder data
    {
      unique_visitors: rand(100..1000),
      page_views: rand(500..2000),
      bounce_rate: rand(20..60),
      avg_session_duration: rand(60..300),
      traffic_sources: {
        direct: rand(30..50),
        organic_search: rand(20..40),
        referral: rand(10..20),
        social: rand(5..15)
      }
    }
  end
  
  def generate_customer_report(start_date, end_date)
    # Generate customer report data
    orders = Order.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      status: 'delivered'
    )
    
    {
      new_customers: User.where(created_at: start_date..end_date).count,
      returning_customers: get_returning_customers(orders),
      customer_acquisition_cost: calculate_cac,
      customer_lifetime_value: calculate_clv
    }
  end
  
  def generate_inventory_report
    # Generate inventory report data
    products = Product.includes(:inventory_item)
    low_stock = products.select { |p| p.inventory_item&.low_stock? }
    
    {
      total_products: products.count,
      low_stock_items: low_stock.count,
      out_of_stock_items: products.select { |p| p.inventory_item&.available_quantity&.zero? }.count,
      average_stock_level: products.map { |p| p.inventory_item&.available_quantity || 0 }.sum.to_f / products.count
    }
  end
  
  def generate_conversion_report(start_date, end_date)
    # Generate conversion report data
    # This is a simplified version
    visits = rand(1000..5000) # Placeholder for actual visit data
    orders = Order.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      status: 'paid'
    ).count
    
    {
      conversion_rate: (orders.to_f / visits * 100).round(2),
      visits: visits,
      conversions: orders,
      cart_abandonment_rate: calculate_cart_abandonment_rate(start_date, end_date)
    }
  end
  
  def run_report
    start_time = Time.current
    
    begin
      update!(status: 'processing')
      
      # Generate report based on report_type
      report_data = case report_type
                    when 'sales'
                      generate_sales_report(filters['start_date'], filters['end_date'])
                    when 'traffic'
                      generate_traffic_report(filters['start_date'], filters['end_date'])
                    when 'customer'
                      generate_customer_report(filters['start_date'], filters['end_date'])
                    when 'inventory'
                      generate_inventory_report
                    when 'conversion'
                      generate_conversion_report(filters['start_date'], filters['end_date'])
                    else
                      {}
                    end
      
      update!(
        data: report_data,
        status: 'completed',
        generated_at: Time.current
      )
      
      true
    rescue => e
      update!(
        status: 'failed',
        data: { error: e.message }
      )
      false
    end
  end
  
  private
  
  def get_top_products(orders, limit = 5)
    # Get top selling products
    order_items = OrderItem.joins(:order).where(orders: { id: orders.pluck(:id) })
    product_sales = order_items.group(:product_id).sum(:quantity)
    
    top_products = product_sales.sort_by { |_, qty| -qty }.first(limit)
    top_products.map do |product_id, quantity|
      product = Product.find(product_id)
      { name: product.name, quantity_sold: quantity, revenue: (product.price * quantity) }
    end
  end
  
  def get_returning_customers(orders)
    # Count customers with more than one order
    customer_counts = orders.group(:user_id).count
    customer_counts.values.count { |count| count > 1 }
  end
  
  def calculate_cac
    # Simplified customer acquisition cost calculation
    # (Total marketing spend / Number of new customers)
    # For now, returning placeholder
    25.00
  end
  
  def calculate_clv
    # Simplified customer lifetime value calculation
    # (Average order value * Purchase frequency * Average customer lifespan)
    # For now, returning placeholder
    350.00
  end
  
  def calculate_cart_abandonment_rate(start_date, end_date)
    # Calculate cart abandonment rate
    carts = Cart.where(updated_at: start_date.beginning_of_day..end_date.end_of_day)
    orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    
    abandoned_carts = carts.count - orders.count
    total_carts = carts.count
    
    total_carts.zero? ? 0 : (abandoned_carts.to_f / total_carts * 100).round(2)
  end
  
  def calculate_revenue_by_date(orders, start_date, end_date)
    revenue_by_date = {}
    
    # Initialize all days in range with zero revenue
    (start_date.to_date..end_date.to_date).each do |date|
      revenue_by_date[date] = 0.0
    end
    
    # Calculate revenue for each day
    orders.each do |order|
      order_date = order.created_at.to_date
      if order_date >= start_date.to_date && order_date <= end_date.to_date
        revenue_by_date[order_date] += order.total
      end
    end
    
    revenue_by_date
  end
end
