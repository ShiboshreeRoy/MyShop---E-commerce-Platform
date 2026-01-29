class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = @product.reviews.approved
  end

  def show
  end

  def new
    @review = @product.reviews.build
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Review was successfully created.'
    else
      render :new
    end
  end

  def edit
    # Check if current user owns the review
    unless @review.user == current_user || current_user.admin?
      redirect_to @product, alert: 'You can only edit your own reviews.'
    end
  end

  def update
    # Check if current user owns the review
    unless @review.user == current_user || current_user.admin?
      redirect_to @product, alert: 'You can only update your own reviews.'
      return
    end

    if @review.update(review_params)
      redirect_to @product, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Check if current user owns the review or is admin
    unless @review.user == current_user || current_user.admin?
      redirect_to @product, alert: 'You can only delete your own reviews.'
      return
    end

    @review.destroy
    redirect_to @product, notice: 'Review was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :title, :content)
  end
end