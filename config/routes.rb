Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations"
  }

  devise_scope :user do
    get "/invite/:code" => "registrations#new", as: :invitation
  end

  get "/welcome" => "dashboard#welcome", as: :welcome
  post "/welcome" => "dashboard#create_group"

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

    get "/invite" => "dashboard#invite", as: :invite
    post "/invite" => "dashboard#send_invitation"

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
