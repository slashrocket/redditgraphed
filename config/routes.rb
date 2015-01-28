Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  match 'home/timeframe/:time', to: 'home#timeframe', via: 'get', as: 'timeframe'
end
