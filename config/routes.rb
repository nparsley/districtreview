Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#index'
  root "shares#index"
  get 'shares', to: 'shares#index'
    resources :shares do
      resources :comments, only: :create
      resources :photos, only: :create
    end
    resources :users, only: :show
end
