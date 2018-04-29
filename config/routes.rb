Rails.application.routes.draw do
  devise_for :users,
  controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  root to: 'meals#search'
  resources :users, only: [:show, :edit, :update, :destroy]

  resources :meals, only: [:index] do
    resources :orders, only: [:show, :create, :new]
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
