Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  match '/timeframe/:time', to: 'home#timeframe', via: 'get', as: 'timeframe'
  match '/title', to: 'home#title', via: 'post', as: 'title'
end
