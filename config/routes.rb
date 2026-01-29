Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  
  root 'home#index'
  
  resources :stores
  resources :products do
    resources :reviews
  end
  resources :orders
  
  get '/cart', to: 'cart#show'
  post '/cart/add/:product_variant_id', to: 'cart#add_item'
  delete '/cart/remove/:product_variant_id', to: 'cart#remove_item'
  patch '/cart/update/:product_variant_id', to: 'cart#update_item'
  
  get '/checkout', to: 'checkout#new'
  post '/checkout', to: 'checkout#create'
  get '/checkout/success', to: 'checkout#show'
  
  get '/dashboard', to: 'dashboard#index'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
