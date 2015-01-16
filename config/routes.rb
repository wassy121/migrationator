Rails.application.routes.draw do

  match "profile" => "users#show", :via => [:get], :as => 'user_show'

  resources :users

  resources :servers do
    resources :packages
  end

  devise_for :users do 
    get '/register' => 'devise/registrations#new'
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end 

  root :to => "welcome#index"

end
