Rails.application.routes.draw do
  devise_for :users
  
  # Root route
  root "home#index"
  
  # Home routes
  get "about", to: "home#about"
  
  # Cart routes
  get "cart", to: "cart#show"
  post "cart/add/:product_id", to: "cart#add_item", as: "add_to_cart"
  patch "cart/update/:product_id", to: "cart#update_item", as: "update_cart_item"
  delete "cart/remove/:product_id", to: "cart#remove_item", as: "remove_from_cart"
  delete "cart/clear", to: "cart#clear", as: "clear_cart"
  
  # Checkout routes
  get "checkout", to: "checkout#show"
  post "checkout", to: "checkout#create_order"
  get "orders/:id/confirmation", to: "checkout#order_confirmation", as: "order_confirmation"
  
  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :products do
      collection do
        patch :bulk_update
      end
    end
    resources :categories
  end
  
  # Resource routes
  resources :categories, only: [:index, :show] do 
    resources :products, only: [:index]
  end
  
  resources :products, only: [:index, :show] do
    collection do
      get :search
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
