class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.admin?
      admin_dashboard
    elsif current_user.merchant?
      merchant_dashboard
    else
      customer_dashboard
    end
  end
  
  private
  
  def admin_dashboard
    @total_users = User.count
    @total_stores = Store.count
    @total_products = Product.count
    @total_orders = Order.count
    @recent_orders = Order.includes(:user, :store).order(created_at: :desc).limit(5)
    @recent_users = User.order(created_at: :desc).limit(5)
    
    render :admin_dashboard
  end
  
  def merchant_dashboard
    @stores = current_user.stores
    @products = Product.where(store: @stores)
    @orders = Order.where(store: @stores)
    @analytics = AnalyticsService.new
    @dashboard_metrics = @analytics.get_dashboard_metrics
    
    render :merchant_dashboard
  end
  
  def customer_dashboard
    @orders = current_user.orders
    @recent_orders = @orders.order(created_at: :desc).limit(5)
    @addresses = [] # In a real app, this would be stored addresses
    
    render :customer_dashboard
  end
end
