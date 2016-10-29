Rails.application.routes.draw do
  mount Redactor2Rails::Engine => '/redactor2_rails'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  root 'pages#home'

  resources :comments
  resources :likes
  resources :signs
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
    shallow do
      resources :discussions
      resources :petitions
      resources :polls
    end
  end

  resources :agendas
  resources :archives
  resources :archive_documents
  resources :memorials

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/dev/emails"
  end
end
