Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  devise_for :users

  get 'welcome/index'

  resources :publications, path: 'content', except: [:show] do
    resources :publishings, path: 'publish', only: [:create]
  end
end
