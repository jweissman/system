Rails.application.routes.draw do
  root controller: 'folders', action: 'index'

  get 'pages/show'

  get '/tags/:name', to: 'tags#show', as: 'tag'

  get '/root', to: 'folders#index'
  get '/root/*path', to: 'pages#show', as: 'page'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :nodes
  resources :folders

  devise_for :users
end
