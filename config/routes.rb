Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  root 'pages#home'

  resources :issues
  resources :following_issues
  resources :campaigns do
    shallow do
      resources :petitions
      resources :memorials
    end
  end
end
