Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :notes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'notes#index'
end
