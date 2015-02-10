Rails.application.routes.draw do
  ##### SEARCH PATHS
  get 'search/index'
  get 'search/results'
  match '/search', to: 'search#searching', via: 'post', as: 'searching'

  ##### HOME PATHS
  get 'home/index'
  root 'home#index'
  match '/timeframe', to: 'home#timeframe', via: 'post', as: 'timeframe'
  match '/title', to: 'home#title', via: 'post', as: 'title'

  ##### USER PATHS
end
