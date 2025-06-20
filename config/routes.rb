Rails.application.routes.draw do
  # Root route - redirects to dashboard
  root 'dashboard#index'

  # Dashboard routes
  get '/dashboard', to: 'dashboard#index', as: :dashboard

  # Position Management routes
  resources :positions, path: 'position-management', as: :position_management do
    collection do
      get '/', to: 'positions#index'
      get '/new', to: 'positions#new'
      post '/create', to: 'positions#create'
    end
    member do
      get '/edit', to: 'positions#edit'
      patch '/update', to: 'positions#update'
      delete '/delete', to: 'positions#destroy'
    end
  end

  # Job Posting routes
  resources :job_posts, path: 'job-posting', as: :job_posting do
    collection do
      get '/', to: 'job_posts#index'
      get '/new', to: 'job_posts#new'
      post '/create', to: 'job_posts#create'
    end
    member do
      get '/edit', to: 'job_posts#edit'
      patch '/update', to: 'job_posts#update'
      delete '/delete', to: 'job_posts#destroy'
    end
  end

  # Pipeline routes
  resources :pipeline, path: 'pipeline', as: :pipeline do
    collection do
      get '/', to: 'pipeline#index'
      get '/kanban', to: 'pipeline#kanban'
      get '/list', to: 'pipeline#list'
    end
    member do
      patch '/update_stage', to: 'pipeline#update_stage'
    end
  end

  # Review Applicants routes
  resources :applicants, path: 'review-applicants', as: :review_applicants do
    collection do
      get '/', to: 'applicants#index'
      get '/search', to: 'applicants#search'
      get '/filter', to: 'applicants#filter'
    end
    member do
      get '/show', to: 'applicants#show'
      patch '/update_status', to: 'applicants#update_status'
      post '/add_note', to: 'applicants#add_note'
    end
  end

  # Settings routes
  namespace :settings do
    get '/', to: 'settings#index'
    
    resources :workflow, only: [:index, :create, :update, :destroy]
    resources :templates, only: [:index, :create, :update, :destroy]
    resources :team_members, only: [:index, :create, :update, :destroy]
    
    # API Integrations
    get '/integrations', to: 'integrations#index'
    post '/integrations/:provider/connect', to: 'integrations#connect'
    delete '/integrations/:provider/disconnect', to: 'integrations#disconnect'
    
    # Notifications
    get '/notifications', to: 'notifications#index'
    patch '/notifications/update', to: 'notifications#update'
  end

  # Health check route for monitoring
  get '/health', to: 'health#check'
end