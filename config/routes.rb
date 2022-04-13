Rails.application.routes.draw do
  resources :chat_rooms do 
    post 'send_message'
  end

  root 'landing_page#index'
  post 'login', to: 'login#login'
  post 'logout', to: 'login#logout'

  resources :login, only: [:index]
  resources :register, only: [:new, :create]

  get 'auth/:provider/callback', to: 'login#google'
  get 'auth/failure', to: redirect('/login')
end
