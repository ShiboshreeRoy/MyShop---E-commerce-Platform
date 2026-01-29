class StoresController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]
  
  def index
    @stores = Store.where(published: true)
  end

  def show
    @products = @store.products.where(status: 'active').page(params[:page])
  end

  def new
    @store = current_user.stores.build
  end

  def create
    @store = current_user.stores.build(store_params)
    
    if @store.save
      redirect_to @store, notice: 'Store was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      redirect_to @store, notice: 'Store was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @store.destroy
    redirect_to stores_url, notice: 'Store was successfully deleted.'
  end
  
  private
  
  def set_store
    @store = Store.find(params[:id])
  end
  
  def store_params
    params.require(:store).permit(:name, :description, :theme, :status, :logo, :favicon, :primary_color, :secondary_color, :published, :visibility, :cover_image)
  end
  
  def check_owner
    redirect_to stores_path, alert: 'Not authorized.' unless @store.user == current_user
  end
end
