Rails.application.routes.draw do
  get 'wikis/index'

  get 'wikis/show'

  get 'wikis/new'

  get 'wikis/edit'

  devise_for :users
  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
