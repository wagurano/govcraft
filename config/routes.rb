Rails.application.routes.draw do
  mount Redactor2Rails::Engine => '/redactor2_rails'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  root 'pages#home'

  get 'about', to: 'pages#about', as: :about

  resources :users
  resources :comments
  resources :likes do
    delete '/', on: :collection, to: 'likes#cancel'
  end
  resources :signs
  resources :reports
  resources :votes do
    collection do
      post :agree
      post :disagree
      post :cancel
    end
  end

  get 'campaigns/:id', to: redirect { |params, req| "/p/#{Project.find_by(id: params[:id]).slug}"}, constraints: lambda { |request, params|
    Project.exists?(id: params[:id])
  }
  get 'c/:id', to: redirect { |params, req| "/p/#{Project.find_by(id: params[:id]).slug}"}, constraints: lambda { |request, params|
    Project.exists?(id: params[:id])
  }
  resources :projects, path: :p do
    get 'events', on: :member
  end
  resources :participations do
    delete :cancel, on: :collection
  end
  resources :speeches
  resources :discussions
  resources :petitions do
    resources :signs
    get 'data', on: :member
  end
  resources :polls do
    get 'social_card', on: :member
  end
  resources :surveys do
    get 'social_card', on: :member
  end
  post 'feedbacks', to: 'feedbacks#create'
  resources :wikis do
    shallow do
      resources :wiki_revisions do
        put 'revert', on: :member
      end
    end
  end
  resources :elections do
    shallow do
      resources :candidates
    end
  end

  resources :people do
    get :search, on: :collection
  end
  resources :races
  resources :players
  resources :thumbs

  resources :events
  resources :articles do
    post :create_by_slack, on: :collection
  end

  class AllTimelineConstraint
    def matches?(request)
      ["timeline", "list"].include? request.query_parameters["mode"]
    end
  end
  get '/archives/:id',
    to: redirect { |params, req| "/timelines/#{params[:id]}?mode=#{req.query_parameters["mode"]}" },
    constraints: AllTimelineConstraint.new
  resources :timelines do
    get 'download', on: :member
  end
  resources :timeline_documents
  resources :archives do
    get :recent_documents, on: :member
    resources :bulk_tasks do
      get :attachment, on: :member
      get :template, on: :collection
    end
    member do
      get :google_drive
      get '/categories/edit', to: 'archives#edit_categories'
      patch :update_categories
      get '/categories/:category_slug', to: 'archives#show', as: :category
    end
  end
  get '/bulk_tasks/start', to: 'bulk_tasks#start', as: :start_bulk_task
  resources :archive_documents do
    get :download, on: :member
  end
  resources :memorials
  get 'google_api/auth_callback', to: 'google_api#auth_callback', as: :auth_callback_google_api
  get 'google_api/auth', to: 'google_api#auth', as: :auth_google_api

  resources :agendas do
    get :new_email, on: :member
    post :send_email, on: :member
  end
  resources :issues, only: [:show]
  resources :opinions, only: [:show]
  resources :speakers

  namespace :admin do
    root 'base#home', as: :home
    get :refresh_assembly_members, to: 'base#refresh_assembly_members'
    resources :agendas
    resources :issues
    resources :speakers
    resources :opinions
    resources :agenda_documents
    resources :roles do
      collection do
        post :add
        delete :remove
      end
    end
    resources :comments
    post '/download_emails', to: 'users#download_emails', as: :download_emails
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/dev/emails"
  end
end
