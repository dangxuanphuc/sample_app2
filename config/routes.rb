Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/chatroom", to: 'messages#index'

  resources :users do
    member do
      resources :followings, :followers, only: %i(index)
    end
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new create edit update)
  resources :microposts do
    resources :comments
    resources :likes, only: [:index, :create, :destroy]
  end
  resources :relationships, only: %i(create destroy)
  resources :conversations, only: %i(create) do
    resources :messages, only: %i(create)

    member do
      post :close
    end
  end
end
