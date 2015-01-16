Rails.application.routes.draw do

  match "profile" => "users#show", :via => [:get], :as => 'user_show'

  resources :servers do
    resources :packages
  end

  devise_for :users

  root :to => "welcome#index"

end
