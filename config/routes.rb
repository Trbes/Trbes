Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    invitations: "invitations",
    omniauth_callbacks: "omniauth_callbacks",
    sessions: "sessions"
  }

  get "/welcome" => "welcome#index", as: :welcome
  post "/welcome" => "welcome#create_group"

  resources :groups, only: %i( new create )
  resources :memberships, only: %i( create destroy )

  post "/validate/user_email" => "validation#user_email"
  post "/validate/group_name" => "validation#group_name"
  post "/validate/group_subdomain" => "validation#group_subdomain"
  post "/validate/group_tagline" => "validation#group_tagline"

  concern :voteable do
    put "upvote"
    put "unvote"
  end

  constraints CustomDomainConstraint do
    resources :groups, only: %i( show new )

    get "join" => "memberships#create"

    resources :posts, only: %i( new create ) do
      concerns :voteable

      resources :comments, only: %i( create destroy update ), shallow: true
    end

    resources :comments, only: [] do
      concerns :voteable
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

    namespace :v1 do
      resources :posts, only: %i( index show update destroy ) do
        concerns :voteable
        put :feature, on: :member
      end
    end

    root to: "groups#show", as: :group_root

    get "/*id", to: "posts#show", as: :post, id: /(?!.*?assets).*/
    patch "/*id", to: "posts#update"
    delete "/*id", to: "posts#destroy"
  end

  get "/groups/:subdomain", to: "groups#show", constraints: { format: // }

  get "/small-teams", to: "landing#small_teams"
  get "/business", to: "landing#business"
  get "/terms", to: "landing#terms"

  root to: "groups#index"
end
