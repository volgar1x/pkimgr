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
    resources :cert_signing_requests, path: "csr", only: [:new] do
      get "accept" => :start_accept, on: :member
      post "accept" => :accept, on: :member
      get "reject" => :start_reject, on: :member
      post "reject" => :reject, on: :member
      get "cancel" => :start_cancel, on: :member
      post "cancel" => :cancel, on: :member
    end
  end
  resources :users

  resource :session, only: [:new, :create, :destroy], controller: "session"
  # resource :profile, only: [:edit, :update]
  scope "/profile", controller: "profiles" do
    get "/" => :edit, as: "edit_profile"
    post "/" => :update, as: "profile"

    get "/import" => :start_import, as: "start_import_profile"
    post "/import" => :import, as: nil
    get "/export" => :start_export, as: "start_export_profile"
    post "/export" => :export, as: nil
    get "/genpkey" => :start_genpkey, as: "start_genpkey_profile"
    post "/genpkey" => :genpkey, as: nil
  end

  root to: 'misc#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
