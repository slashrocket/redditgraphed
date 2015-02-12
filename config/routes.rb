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
end
