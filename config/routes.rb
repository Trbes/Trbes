Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    invitations: "invitations"
  }

  devise_scope :user do
    put "/invitation" => "invitations#update", as: :update_invitation
  end

  get "/welcome" => "welcome#index", as: :welcome
  post "/welcome" => "welcome#create_group"

  resources :groups, only: %i( new create )

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: %i( show new )
    resources :posts, only: %i( show new create ) do
      resources :comments, only: %i( create destroy )
    end
    resources :votes, only: [] do
      put "upvote"
    end

    namespace :admin do
      resources :dashboard, only: %i( index )
      resource :group, only: %i( edit update destroy )
      resources :memberships, only: %i( index )
      resources :collections, only: %i( index show new create edit update destroy )
    end

    get "/invite" => "welcome#invite", as: :invite
    post "/invite" => "welcome#send_invitation"

    root to: "groups#show", as: :group_root
  end

  get "/groups/:subdomain", to: "groups#show"

  get "/frontend/posts" => "frontend#posts"
  get "/frontend/sign_up" => "frontend#sign_up"
  get "/frontend/sign_in" => "frontend#sign_in"
  get "/frontend/thank_you" => "frontend#thank_you"
  get "/frontend/invite" => "frontend#invite"
  get "/frontend/create_group" => "frontend#create_group"
  get "/frontend/single_post" => "frontend#single_post"

  root to: "dashboard#index"
end
