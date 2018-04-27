Rails.application.routes.draw do
  devise_for :users,
  controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  root to: 'meals#filter'
  resources :users, only: [:show, :edit, :update, :destroy]

  resources :meals, only: [:index, :show] do
    resources :orders, only: [:new, :create] do
        resources :payments, only: [:new, :create]
    end
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
