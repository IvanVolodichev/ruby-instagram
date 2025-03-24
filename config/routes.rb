Rails.application.routes.draw do
  devise_for :users
  root to: redirect("/home")
  get "/home",  to: "home#index"
  resources :users, only: [] do
    member do
      post :follow, to: "followers#follow"
      delete :unfollow, to: "followers#unfollow"
      get :followers, to: "followers#followers"
      get :following, to: "followers#following"
    end
    resources :posts, only: [ :index ]
  end

  resources :posts, except: [ :index ] do
    resources :comments, only: [ :create, :destroy ]
    post "like", to: "likes#create"
    delete "unlike", to: "likes#destroy"
  end
end
