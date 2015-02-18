Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    invitations: "invitations"
  }

  get "/welcome" => "welcome#index", as: :welcome
  post "/welcome" => "welcome#create_group"

  resources :groups, only: %i( new create )

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
      resources :memberships, only: %i( update )
      resources :collections, only: %i( index show new create edit update destroy )
      resources :collection_posts, only: %i( create update )
    end

    devise_scope :user do
      get "/invitation/new" => "invitations#new", as: :new_invitation
      post "/invitation" => "invitations#create", as: :create_invitation
      put "/invitation" => "invitations#update", as: :update_invitation
    end

    root to: "groups#show", as: :group_root
  end

  get "/groups/:subdomain", to: "groups#show"

  # Front pages
  get "/teams", to: "landing#teams"
  get "/customer-communities", to: "landing#customer_communities"

  # Plain front-end templates
  get "/frontend/posts" => "frontend#posts"
  get "/frontend/sign_up" => "frontend#sign_up"
  get "/frontend/sign_in" => "frontend#sign_in"
  get "/frontend/thank_you" => "frontend#thank_you"
  get "/frontend/invite" => "frontend#invite"
  get "/frontend/create_group" => "frontend#create_group"
  get "/frontend/single_post" => "frontend#single_post"
  get "/frontend/home" => "frontend#home"

  root to: "dashboard#index"
end
