Rails.application.routes.draw do

  ##### SEARCH PATHS
  get 'search/index'
  get 'search/results'
  match 'search/results', to: 'search#results', via: 'post', as: 'searching'

  ##### HOME PATHS
  get 'home/index'
  root 'home#index'
  match '/timeframe', to: 'home#timeframe', via: 'post', as: 'timeframe'
  match '/title', to: 'home#title', via: 'post', as: 'title'

  ##### SHOW PATHS
  match '/post/:title', to: 'post#show', via: 'get', as: 'post'

  ##### USER PATHS
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  devise_scope :users do
    match 'users/:id', to: "user_pages#show", via: 'get', as: 'user_page'
  end
  match '/dashboard', to: 'user_pages#index', via: 'get', as: 'dashboard'
end
