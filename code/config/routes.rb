Rails.application.routes.draw do

  namespace :v1 do

    post '/login', to: 'auth#login'
    post '/signup', to: 'auth#signup'

  end

end
