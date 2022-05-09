Rails.application.routes.draw do
  
  root 'staticpages#home'
  get  '/help',    to: 'staticpages#help' 
  get  '/about',   to: 'staticpages#about'
  get  '/contact', to: 'staticpages#contact'
  get  '/signup',  to: 'users#new'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
  # GET /account_activation/トークン/edit 
  resources :account_activations, only: [:edit]
end
