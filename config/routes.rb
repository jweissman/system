Rails.application.routes.draw do
  root to: 'pages#show'

  get 'pages/show'

  get '/tags/:name', to: 'tags#show', as: 'tag'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :nodes, only: [:index,:new,:create,:edit,:update,:destroy]
  # resources :virtual_nodes
  resources :folders, only: [:index,:new,:create,:update,:destroy]
  resources :mounts
  resources :remote_mounts
  resources :symlinks

  resource :virtual_folder
  resource :virtual_node

  devise_for :users

  get '*path/nodes', to: 'nodes#index', as: 'path_nodes'
  get '*path/folders', to: 'folders#index', as: 'path_folders'
  get '*path', to: 'pages#show', as: 'page'
end
