Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  devise_for :users

  get 'welcome/index'

  resources :projects, except: :show, param: :name do
    resources :publishings, path: 'publish', only: :create
  end

  namespace :pubsub do
    namespace :deploy do
      post "/", to: "messages#create"
    end
    namespace :cleanup do
      post "/", to: "messages#create"
    end
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :projects, only: :show
    end
  end
end
