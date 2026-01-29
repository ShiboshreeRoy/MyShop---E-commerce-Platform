class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [:update_item, :remove_item]
  
  def show
    @cart_items = @cart.cart_items.includes(:product_variant)
    @total = @cart.total_price
  end

  def add_item
    product_variant = ProductVariant.find(params[:product_variant_id])
    quantity = params[:quantity].to_i || 1
    
    # Check if item already exists in cart
    cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
    
    if cart_item.persisted?
      cart_item.quantity += quantity
    else
      cart_item.quantity = quantity
      cart_item.unit_price = product_variant.price
    end
    
    if cart_item.save
      redirect_to cart_path, notice: 'Item added to cart successfully.'
    else
      redirect_to cart_path, alert: 'Failed to add item to cart.'
    end
  end

  def remove_item
    if @cart_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart successfully.'
    else
      redirect_to cart_path, alert: 'Failed to remove item from cart.'
    end
  end

  def update_item
    quantity = params[:quantity].to_i
    
    if quantity <= 0
      @cart_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart.'
    elsif @cart_item.update(quantity: quantity)
      redirect_to cart_path, notice: 'Cart updated successfully.'
    else
      redirect_to cart_path, alert: 'Failed to update cart item.'
    end
  end
  
  private
  
  def set_cart
    @cart = Cart.find_or_create_by(user: current_user)
  end
  
  def set_cart_item
    @cart_item = @cart.cart_items.find_by!(product_variant_id: params[:product_variant_id])
  end
end
