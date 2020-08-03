Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  devise_for :users

  get 'welcome/index'

  resources :publications, except: :show, param: :name, path: 'content' do
    resources :publishings, path: 'publish', only: :create
  end

  namespace :pubsub do
    namespace :publish do
      post "/", to: "messages#create"
    end
    namespace :unpublish do
      post "/", to: "messages#create"
    end
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :publications, only: :show, param: :name
    end
  end
end
