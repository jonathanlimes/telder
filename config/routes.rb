Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :notes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#home'
  get 'tagged' => 'notes#tagged', :as => 'tagged'
  get 'join' => 'notes#join', :as => 'join'
  post 'export_email' => 'notes#export_email', :as => 'export_email'

  # To mount Action Cable, and to listen to ws://localhost:3000/cable
  mount ActionCable.server => '/cable'

end
