Rails.application.routes.draw do

  get "filters", to: "meals#search"

  devise_for :users,
  controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :users, only: [:show, :edit, :update, :destroy]

  resources :meals, only: [:index, :show] do
    resources :orders, only: [:show, :create]
  end

  root to: 'pages#home'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
