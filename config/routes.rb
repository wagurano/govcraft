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
  resources :likes
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

  resources :campaigns do
    get 'events', on: :member
  end
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

  resources :events
  resources :articles
  resources :agendas
  resources :archives do
    get 'download', on: :member
  end
  resources :archive_documents
  resources :memorials

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/dev/emails"
  end
end
