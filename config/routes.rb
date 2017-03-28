Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :notes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#home'
  get 'tagged' => 'notes#tagged', :as => 'tagged'
end
