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

  resources :issues
  resources :following_issues

  get 'campaigns/:id', to: redirect { |params, req| "/c/#{Campaign.find_by(id: params[:id]).slug}"}, constraints: lambda { |request, params|
    Campaign.exists?(id: params[:id])
  }
  resources :campaigns, path: :c do
    get 'events', on: :member
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
  resources :archives do
    get 'download', on: :member
  end
  resources :archive_documents
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
