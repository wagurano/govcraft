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
  get 'weekly', to: 'pages#weekly', as: :weekly

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

  resources :issues
  resources :following_issues

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
  resources :agendas

  class AllTimelineConstraint
    def matches?(request)
      request.query_parameters["mode"] == "timeline"
    end
  end
  get '/archives/:id',
    to: redirect { |params, req| "/timelines/#{params[:id]}?mode=timeline" },
    constraints: AllTimelineConstraint.new
  resources :timelines do
    get 'download', on: :member
  end
  resources :timeline_documents
  resources :archives do
    member do
      get '/categories/edit', to: 'archives#edit_categories'
      patch :update_categories
      get '/categories/:category_slug', to: 'archives#show', as: :category
    end
  end
  resources :archive_documents do
    get :download, on: :member
  end
  resources :memorials

  namespace :admin do
    root 'base#home', as: :home
    resources :roles do
      collection do
        post :add
        delete :remove
      end
    end
    resources :comments
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/dev/emails"
  end
end
