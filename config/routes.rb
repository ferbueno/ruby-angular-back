Rails.application.routes.draw do
  apipie
  resources :users
  resources :people
  resources :login
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
