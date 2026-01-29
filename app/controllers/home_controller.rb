class HomeController < ApplicationController
  def index
    @featured_products = Product.limit(8)
    @stores = Store.where(published: true).limit(6)
  end
end
