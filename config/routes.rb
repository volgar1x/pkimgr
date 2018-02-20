Rails.application.routes.draw do
  concern :has_crypto_keys do
    resources :crypto_keys, only: [:new, :create], path: "keys"
  end

  resources :crypto_keys, only: [], path: "keys" do
    get "export" => :start_export, on: :member
    post "export" => :export, on: :member
  end

  resources :certificates do
    get "renew" => :renew, on: :member
  end
  resources :cert_signing_requests, path: "cert/requests"
  resources :cert_profiles, path: "cert/profiles"

  resources :authorities do
    concerns :has_crypto_keys
    resources :certificates, shallow: true
    resources :cert_signing_requests, path: "csr", only: [:new] do
      get "accept" => :start_accept, on: :member
      post "accept" => :accept, on: :member
      get "reject" => :start_reject, on: :member
      post "reject" => :reject, on: :member
      get "cancel" => :start_cancel, on: :member
      post "cancel" => :cancel, on: :member
    end
  end
  resources :users do
    concerns :has_crypto_keys
  end

  resource :session, only: [:new, :create, :destroy], controller: "session"
  # resource :profile, only: [:edit, :update]
  scope "/profile", controller: "profiles" do
    get "/" => :edit, as: "edit_profile"
    post "/" => :update, as: "profile"
  end

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
