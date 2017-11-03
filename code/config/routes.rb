Rails.application.routes.draw do

  namespace :v1 do

    resources :conversations, only: %i{ index create update destroy show }

    post '/login', to: 'auth#login'
    post '/signup', to: 'auth#signup'

  end

end
