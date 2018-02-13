Rails.application.routes.draw do
  resources :certificates
  resources :cert_signing_requests
  resources :cert_profile_constraints
  resources :cert_profiles
  resources :authorities do
    get "keys" => :edit_keys, on: :member
    patch "keys" => :update_keys, on: :member
    get "genpkey" => :edit_genpkey, on: :member
    patch "genpkey" => :update_genpkey, on: :member
  end
  resources :users

  resource :session, only: [:new, :create, :destroy], controller: "session"
  resource :profile, only: [:edit, :update, :destroy]

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
