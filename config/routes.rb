Rails.application.routes.draw do

  resources :charges, only: [:new, :create, :destroy]

  resources :wikis

  resources :collaborators, only: [:create, :destroy]
  devise_for :users
  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
