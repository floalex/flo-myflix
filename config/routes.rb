Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  
  root 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  post 'update_queue', to: 'queue_items#update_queue'  
  get '/my_queue', to: 'queue_items#index'
  
  get '/people', to: 'relationships#index'
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confimration', to: 'forgot_passwords#confirm'
  
  get '/expired_token', to: 'pages#expired_token'
  
  resources :queue_items, only: [:create, :destroy]
  
  resources :videos, only: [:show] do
    collection do
      get "/search", to: "videos#search"
      get "/advanced_search", to: "videos#advanced_search", as: :advanced_search
    end
    resources :reviews, only: [:create]
  end
  
  resources :users, only: [:create, :show] 
  resources :relationships, only: [:create, :destroy]  
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  
  resources :invitations, only: [:new, :create]
  
  namespace :api do
    namespace :v1 do
      resources :videos, only: [:show]
      resources :categories, only: [:show] 
    end
  end
  
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end
  
  mount StripeEvent::Engine, at: '/stripe_events'
  
end
