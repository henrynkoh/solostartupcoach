# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # API routes
  namespace :api do
    namespace :v1 do
      get :auth, to: 'auth#me'
      
      resources :startup_tips do
        member do
          post :generate_video
        end
      end
      
      resources :videos do
        member do
          post :retry
          post :retry_upload
        end
      end
      
      resources :jobs, only: [:index, :show] do
        member do
          post :retry
          post :cancel
        end
      end
      
      get :statistics, to: 'statistics#index'
      get :health, to: 'health#index'
    end
  end

  # Health check
  get :health, to: 'health#index'

  # Catch all route for React Router
  get '*path', to: 'application#index', constraints: ->(request) { !request.xhr? && request.format.html? }
  
  # Root route
  root 'application#index'
end
