Rails.application.routes.draw do
  get 'order/new', to: 'orders#new'

  get 'order/create', to: 'orders#create'
  get 'order/:id/edit', to: 'order#edit', as: :edit_order
  get 'order/:id/update', to: 'order#update', as: :update_order

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
