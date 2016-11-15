Rails.application.routes.draw do
  root controller: 'folders', action: 'index'

  get 'pages/show'

  get '/tags/:name', to: 'tags#show', as: 'tag'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :nodes
  # resources :virtual_nodes
  resources :folders
  resources :mounts
  resource :virtual_folder
  resource :virtual_node

  devise_for :users

  get '*path', to: 'pages#show', as: 'page'
end
