Rails.application.routes.draw do
  resources :categories
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end  

  resources :road_conditions do
    resources :comments, only: [:create, :destroy] do
      resource :comment_favorites, only: [:create, :destroy]
    end
    resource :favorites, only: [:create, :destroy]  
    
    collection do
      get 'confirm'  # confirm用のアクション
    end
  end

resources :notifications, only: [:index]



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root :to => 'homes#top'
end
