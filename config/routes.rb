Rails.application.routes.draw do
  resources :certificates do
    get "renew" => :renew, on: :member
  end
  resources :cert_signing_requests, path: "cert/requests"
  resources :cert_profiles, path: "cert/profiles"
  resources :authorities do
    get "import" => :start_import, on: :member
    post "import" => :import, on: :member
    get "genpkey" => :start_genpkey, on: :member
    post "genpkey" => :genpkey, on: :member
    get "export" => :start_export, on: :member
    post "export" => :export, on: :member

    resources :certificates, shallow: true
    resources :cert_signing_requests, shallow: true, path: "csr"
  end
  resources :users

  resource :session, only: [:new, :create, :destroy], controller: "session"
  resource :profile, only: [:edit, :update, :destroy]

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
