class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_store_owner, only: [:edit, :update, :destroy]
  
  def index
    @products = Product.where(status: 'active').includes(:store).page(params[:page])
  end

  def show
    @related_products = Product.where(store: @product.store, status: 'active').where.not(id: @product.id).limit(4)
    @reviews = @product.reviews.approved
    @new_review = @product.reviews.build if user_signed_in?
  end

  def new
    @store = current_user.stores.find(params[:store_id]) if params[:store_id]
    @product = @store ? @store.products.build : current_user.stores.first&.products&.build
    @product.product_variants.build if @product
  end

  def create
    @store = current_user.stores.find(params[:store_id]) if params[:store_id]
    
    # Clean up category_ids to remove empty strings
    cleaned_params = product_params.dup
    if cleaned_params[:category_ids].present?
      cleaned_params[:category_ids] = cleaned_params[:category_ids].reject(&:blank?)
    end
    
    @product = @store ? @store.products.build(cleaned_params) : current_user.stores.first&.products&.build(cleaned_params)
    
    # Handle gallery images separately to remove empty values
    if params[:product][:gallery_images].present?
      gallery_images = params[:product][:gallery_images].reject(&:blank?)
      gallery_images.each do |image|
        @product.gallery_images.attach(image) if image.respond_to?(:tempfile)
      end
    end
    
    if @product&.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    # Clean up category_ids to remove empty strings
    cleaned_params = product_params.dup
    if cleaned_params[:category_ids].present?
      cleaned_params[:category_ids] = cleaned_params[:category_ids].reject(&:blank?)
    end
    
    # Handle gallery images separately to remove empty values
    if params[:product][:gallery_images].present?
      gallery_images = params[:product][:gallery_images].reject(&:blank?)
      gallery_images.each do |image|
        @product.gallery_images.attach(image) if image.respond_to?(:tempfile)
      end
    end
    
    if @product.update(cleaned_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end
  
  private
  
  def set_product
    @product = Product.includes(:store, :product_variants, :categories).find(params[:id])
  end
  
  def product_params
    params.require(:product).permit(:name, :description, :short_description, :price, :compare_at_price, :cost_per_item, :status, :sku, :barcode, :condition, :taxable, :featured, :stock_quantity, :low_stock_threshold, :allow_out_of_stock_purchases, :weight, :dimensions_length, :dimensions_width, :dimensions_height, :material, :care_instructions, :meta_title, :meta_description, :tags, :store_id, :image, category_ids: [], gallery_images: [], product_variants_attributes: [:id, :name, :price, :stock_quantity, :sku, :available, :_destroy])
  end
  
  def check_store_owner
    redirect_to products_path, alert: 'Not authorized.' unless @product.store.user == current_user
  end
end
