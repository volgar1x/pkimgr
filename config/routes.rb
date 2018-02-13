Rails.application.routes.draw do
  resources :certificates do
    get "renew" => :renew, on: :member
  end
  resources :cert_signing_requests
  resources :cert_profile_constraints
  resources :cert_profiles
  resources :authorities do
    get "import" => :start_import, on: :member
    post "import" => :import, on: :member
    get "genpkey" => :start_genpkey, on: :member
    post "genpkey" => :genpkey, on: :member
    get "pkey" => :start_pkey, on: :member
    post "pkey" => :pkey, on: :member

    resources :certificates, shallow: true
  end
  resources :users

  resource :session, only: [:new, :create, :destroy], controller: "session"
  resource :profile, only: [:edit, :update, :destroy]

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
