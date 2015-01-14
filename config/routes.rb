Migrationator::Application.routes.draw do

  match "profile" => "users#show"

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
