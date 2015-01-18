Rails.application.routes.draw do
  resources :home
  get 'home/index'
  root 'home#index'
end
