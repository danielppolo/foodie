Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update, :destroy]

  resources :meals, only: [:index, :show] do
    resources :orders, only: [:new, :create] do
        resources :payments, only: [:new, :create]
    end
  end

  root to: 'pages#home'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
