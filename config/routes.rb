Rails.application.routes.draw do
  
  get 'comments/create'
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'staticpages#home'
  get  '/help',    to: 'staticpages#help' 
  get  '/about',   to: 'staticpages#about'
  get  '/contact', to: 'staticpages#contact'
  get  '/signup',  to: 'users#new'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
  # memberだと、 users/:id/following, collectionだと users/following 
    member do
      # GET request, following action, following_user_path(:id)
      get :following, :followers
    end
  end
  # GET /account_activation/トークン/edit 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts do
    resource :favorites, only: [:show, :create, :destroy]
    resource :comments, only: [:create, :destroy]
  end
  resources :relationships,       only: [:create, :destroy]
end
