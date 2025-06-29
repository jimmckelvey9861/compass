Rails.application.routes.draw do
  # Employees routes
  namespace :employees do
    get 'dashboard', to: 'employees#dashboard'
    post 'clock_in', to: 'employees#clock_in'
    post 'clock_out', to: 'employees#clock_out'
  end

  # Root route
  root 'dashboard#index'

  # Managers routes
  get '/managers/dashboard', to: 'managers#dashboard', as: :managers_dashboard
  get '/managers/schedule', to: 'managers#schedule', as: :managers_schedule
  get '/managers/timesheets', to: 'managers#timesheets', as: :managers_timesheets
  post 'shifts/:id/assign', to: 'managers#assign_shift', as: :assign_shift

  # Position Management routes
  resources :positions do
    member do
      patch :update_status
    end
  end

  # Job Posting routes
  resources :job_posts

  # Pipeline routes
  resources :pipelines do
    collection do
      get :kanban
      get :list
    end
    member do
      patch :update_stage
    end
  end

  # Review Applicants routes
  resources :applicants do
    collection do
      get :search
      get :filter
    end
    member do
      patch :update_status
      post :add_note
    end
  end

  # Settings routes
  namespace :settings do
    root to: 'settings#index'
    
    resources :workflows, only: [:index, :create, :update, :destroy]
    resources :templates, only: [:index, :create, :update, :destroy]
    resources :team_members, only: [:index, :create, :update, :destroy]
    
    # API Integrations
    resources :integrations, only: [:index] do
      member do
        post :connect
        delete :disconnect
      end
    end
    
    # Notifications
    resources :notifications, only: [:index] do
      collection do
        patch :update
      end
    end
  end

  # Health check route for monitoring
  get '/health', to: 'health#check'
end