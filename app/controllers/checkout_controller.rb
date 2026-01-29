class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :ensure_cart_has_items
  
  def new
    @cart_items = @cart.cart_items.includes(:product_variant)
    @total = @cart.total_price
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.store = @cart.cart_items.first.product_variant.product.store
    @order.subtotal = @cart.subtotal
    @order.total = @cart.total
    
    # Create order items from cart items
    @cart.cart_items.each do |cart_item|
      @order.order_items.build(
        product_variant: cart_item.product_variant,
        quantity: cart_item.quantity,
        unit_price: cart_item.unit_price,
        total_price: cart_item.total_price,
        name: cart_item.product_variant.display_name
      )
    end
    
    if @order.save
      # Process payment
      payment_service = PaymentService.new(@order, payment_params)
      payment_result = payment_service.process_payment
      
      if payment_result[:success]
        # Clear the cart
        @cart.clear!
        redirect_to checkout_success_path, notice: 'Order placed successfully!'
      else
        # If payment fails, remove the order
        @order.destroy
        flash[:alert] = payment_result[:message]
        render :new
      end
    else
      render :new
    end
  end

  def show
    # Success page after checkout
  end
  
  private
  
  def set_cart
    @cart = Cart.find_by(user: current_user)
    redirect_to cart_path, alert: 'Your cart is empty.' unless @cart&.cart_items&.any?
  end
  
  def ensure_cart_has_items
    redirect_to cart_path, alert: 'Your cart is empty.' unless @cart&.cart_items&.any?
  end
  
  def order_params
    params.require(:order).permit(:special_instructions, :shipping_address, :billing_address)
  end
  
  def payment_params
    params.require(:payment).permit(:method, :token, :amount)
  end
end
