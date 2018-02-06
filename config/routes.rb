Rails.application.routes.draw do
  root 'root#home'

  resources :certificates
  resources :cert_signing_requests
  resources :cert_profile_constraints
  resources :cert_profiles
  resources :authorities
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
