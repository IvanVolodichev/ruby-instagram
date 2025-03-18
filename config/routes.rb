Rails.application.routes.draw do
  devise_for :users
  root to: redirect("/home")
  get "/home",  to: "home#index"
  resources :users, only: [] do
    member do
      post :follow
      delete :unfollow
      get :followers
      get :following
    end
    resources :posts, only: [ :index ]
  end

  resources :posts, except: [ :index ] do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
  end
end
