class AnalyticsService
  def initialize(store = nil)
    @store = store
  end

  def get_dashboard_metrics(start_date = 30.days.ago, end_date = Date.current)
    {
      total_sales: calculate_total_sales(start_date, end_date),
      total_orders: calculate_total_orders(start_date, end_date),
      total_customers: calculate_total_customers(start_date, end_date),
      conversion_rate: calculate_conversion_rate(start_date, end_date),
      avg_order_value: calculate_avg_order_value(start_date, end_date),
      top_selling_products: get_top_selling_products(start_date, end_date, 5),
      revenue_by_day: get_revenue_by_day(start_date, end_date)
    }
  end

  def calculate_total_sales(start_date, end_date)
    orders = get_orders_in_range(start_date, end_date)
    orders.sum(:total).round(2)
  end

  def calculate_total_orders(start_date, end_date)
    get_orders_in_range(start_date, end_date).count
  end

  def calculate_total_customers(start_date, end_date)
    orders = get_orders_in_range(start_date, end_date)
    orders.distinct.count(:user_id)
  end

  def calculate_conversion_rate(start_date, end_date)
    # This is a simplified version - in a real app you'd need visitor data
    orders_count = calculate_total_orders(start_date, end_date)
    # Assuming 100 visitors per order for demo purposes
    visitors_count = orders_count * 100
    return 0 if visitors_count.zero?
    (orders_count.to_f / visitors_count * 100).round(2)
  end

  def calculate_avg_order_value(start_date, end_date)
    orders = get_orders_in_range(start_date, end_date)
    return 0.0 if orders.empty?
    orders.average(:total).round(2)
  end

  def get_top_selling_products(start_date, end_date, limit = 10)
    order_items = OrderItem.joins(order: :store)
                          .where(orders: { 
                            created_at: start_date.beginning_of_day..end_date.end_of_day,
                            status: 'delivered'
                          })
    
    order_items = order_items.where(orders: { store_id: @store.id }) if @store
    
    top_products = order_items
                   .joins(:product_variant)
                   .group('product_variants.name')
                   .sum(:quantity)
                   .sort_by { |_, qty| -qty }
                   .first(limit)
    
    top_products.map do |product_name, quantity|
      {
        name: product_name,
        quantity_sold: quantity
      }
    end
  end

  def get_revenue_by_day(start_date, end_date)
    orders = get_orders_in_range(start_date, end_date)
    
    # Create a hash to store revenue by day
    revenue_by_day = {}
    
    # Initialize all days in range with zero revenue
    (start_date.to_date..end_date.to_date).each do |date|
      revenue_by_day[date] = 0.0
    end
    
    # Calculate revenue for each day
    orders.each do |order|
      order_date = order.created_at.to_date
      if order_date >= start_date.to_date && order_date <= end_date.to_date
        revenue_by_day[order_date] += order.total
      end
    end
    
    # Convert to array of hashes for charting
    revenue_by_day.map do |date, revenue|
      {
        date: date,
        revenue: revenue.round(2)
      }
    end
  end

  def get_monthly_sales_comparison(current_year = Date.current.year)
    months = []
    12.times do |i|
      month = i.months.ago.beginning_of_month
      start_date = month.change(year: current_year)
      end_date = start_date.end_of_month
      
      monthly_sales = calculate_total_sales(start_date, end_date)
      monthly_orders = calculate_total_orders(start_date, end_date)
      
      months << {
        month: start_date.strftime('%B'),
        year: current_year,
        sales: monthly_sales,
        orders: monthly_orders
      }
    end
    
    months
  end

  def get_customer_acquisition_trend(start_date, end_date)
    # Group customers by signup date manually instead of using groupdate
    customers_by_date = {}
    
    # Initialize all days in range with zero customers
    (start_date.to_date..end_date.to_date).each do |date|
      customers_by_date[date] = 0
    end
    
    # Count customers by signup date
    users = User.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    users.each do |user|
      signup_date = user.created_at.to_date
      if signup_date >= start_date.to_date && signup_date <= end_date.to_date
        customers_by_date[signup_date] += 1
      end
    end
    
    customers_by_date.map do |date, count|
      {
        date: date,
        new_customers: count
      }
    end
  end

  def get_inventory_alerts(threshold = 5)
    products = Product.includes(:inventory_item)
    low_stock_items = products.select { |p| p.inventory_item&.low_stock?(threshold) }
    
    low_stock_items.map do |product|
      inventory = product.inventory_item
      {
        product_name: product.name,
        current_stock: inventory&.available_quantity || 0,
        threshold: threshold
      }
    end
  end

  private

  def get_orders_in_range(start_date, end_date)
    orders = Order.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      status: 'delivered'
    )
    
    orders = orders.where(store_id: @store.id) if @store
    orders
  end
end