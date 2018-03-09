Rails.application.routes.draw do
  concern :has_crypto_keys do
    resources :crypto_keys, only: [:new, :create], path: "keys"
  end

  resources :crypto_keys, only: [], path: "keys" do
    get "export" => :start_export, on: :member
    post "export" => :export, on: :member
  end

  resources :certificates, only: [:index, :show] do
    get "renew" => :renew, on: :member
    get "download" => :download, on: :member
  end

  resources :cert_signing_requests, path: "cert/requests", only: [:create] do
    post "new" => :start_create, on: :collection, as: :start_create
  end

  resources :authorities do
    concerns :has_crypto_keys
    resources :cert_signing_requests, path: "csr", only: [:new] do
      get "accept" => :start_accept, on: :member
      post "accept" => :accept, on: :member
      get "reject" => :start_reject, on: :member
      post "reject" => :reject, on: :member
      get "cancel" => :start_cancel, on: :member
      post "cancel" => :cancel, on: :member
    end
    get "users/new" => :start_invite_user, on: :member, as: "invite_user"
    post "users" => :invite_user, on: :member
    delete "users/:user_id" => :kick_user, on: :member, as: "kick_user"
  end

  resources :users, only: [:show]

  resource :session, only: [:new, :create, :destroy], controller: "session"

  resource :profile, only: [:edit, :update] do
    concerns :has_crypto_keys
    get "/", to: redirect("/profile/edit")
    get "/password" => :edit_password
    put "/password" => :update_password
    patch "/password" => :update_password
  end

  namespace :admin do
    get "/" => "misc#dashboard"

    resources :users
    resources :cert_profiles, path: "cert/profiles"
  end

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
