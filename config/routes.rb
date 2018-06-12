Rails.application.routes.draw do
  mount Redactor2Rails::Engine => '/redactor2_rails'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  get '404', :to => 'application#page_not_found'

  root 'pages#home'

  get 'about', to: 'pages#about', as: :about
  get 'components', to: 'pages#components'
  get 'privacy', to: "pages#privacy", as: 'privacy'
  get 'terms', to: "pages#terms", as: 'terms'

  resources :users
  resources :comments
  resources :notes
  resources :likes do
    delete '/', on: :collection, to: 'likes#cancel'
  end
  resources :signs
  resources :reports
  resources :votes do
    collection do
      post :agree
      post :disagree
      post :neutral
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
  resources :episodes do
    collection do
      get 'change2020'
      get 'change2020_polls'
    end
  end
  resources :organizers
  resources :participations do
    delete :cancel, on: :collection
  end
  resources :speeches
  resources :statements
  concern :statementable do
    member do
      get 'edit_message_to_agent'
      put 'update_message_to_agent'
      get 'edit_agents'
      put 'add_agent'
      delete 'remove_agent'
      get 'new_comment_agent'
      get 'update_statement_agent'
    end
  end

  resources :project_categories
  resources :stories
  resources :discussions do
    member do
      put :unpin
      put :pin
    end
  end
  resources :discussion_categories
  resources :sympathies
  resources :petitions, concerns: :statementable do
    resources :signs
    member do
      get 'data'
    end
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
  resources :people do
    get :search, on: :collection
  end
  resources :races
  resources :players
  resources :thumbs

  resources :events, concerns: :statementable do
    member do
      get 'data'
    end
  end
  resources :sns_events do
    get 'new_or_edit', on: :collection
  end
  resources :articles do
    post :create_by_slack, on: :collection
  end

  get 'specials/voteaward2018'

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
    member do
      get :new_email
      post :send_email
      get :widget
      get '/themes/widget/:theme_slug', action: :theme_single_widget, as: :theme_single_widget
    end
    collection do
      get '/themes/:theme_slug', action: :theme, as: :theme
      get '/themes/widget/:theme_slug', action: :theme_widget, as: :theme_widget
    end
  end
  resources :issues
  resources :following_issues
  resources :opinions, only: [:show] do
    member do
      get :vote_widget
    end
  end
  resources :agents
  resources :agencies do
    member do
      get :agents
    end
  end

  namespace :admin do
    root 'base#home', as: :home
    get :refresh_assembly_members, to: 'base#refresh_assembly_members'
    resources :agendas
    resources :issues
    resources :agencies
    resources :agents
    resources :positions
    resources :opinions do
      collection do
        get :new_or_edit
      end
    end
    resources :agenda_documents
    resources :agenda_themes do
      member do
        post :add_agenda
        delete :remove_agenda
      end
    end
    resources :roles do
      collection do
        post :add
        delete :remove
      end
    end
    resources :comments
    post '/download_emails', to: 'users#download_emails', as: :download_emails
  end

  if Rails.env.development? or Rails.env.staging?
    mount LetterOpenerWeb::Engine, at: "/dev/emails"
  end
end
