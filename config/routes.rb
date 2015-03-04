Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    invitations: "invitations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  get "/welcome" => "welcome#index", as: :welcome
  post "/welcome" => "welcome#create_group"

  resources :groups, only: %i( new create )
  resources :memberships, only: %i( create destroy )

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: %i( show new )
    resources :posts, only: %i( show new create ) do
      put "upvote"

      resources :comments, only: %i( create destroy )
    end

    resources :comments, only: [] do
      put "upvote"
    end

    namespace :admin do
      resources :dashboard, only: %i( index )
      resource :group, only: %i( edit update destroy )
      resources :posts, only: %i( index update )
      resources :comments, only: %i( index update ) do
        get :favourite, on: :member
        get :unfavourite, on: :member
      end
      resources :memberships, only: %i( index update destroy )
      resources :collections, only: %i( index show new create edit update destroy )
      resources :collection_posts, only: %i( create update destroy )
    end

    devise_scope :user do
      get "/invitation/new" => "invitations#new", as: :new_invitation
      post "/invitation" => "invitations#create", as: :create_invitation
      put "/invitation" => "invitations#update", as: :update_invitation
    end

    root to: "groups#show", as: :group_root
  end

  get "/groups/:subdomain", to: "groups#show"

  get "/explore", to: "groups#index"

  root to: "landing#index"
end
