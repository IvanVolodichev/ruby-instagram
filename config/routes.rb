Rails.application.routes.draw do
  get "/home", to: "home#index"
  resources :users do
    resources :followers, only: [ :index, :create, :destroy ]
    resources :posts do
        resources :comments, only: [ :index, :create, :destroy ]
        resources :likes, only: [ :index, :create, :destroy ]
      end
  end
end
