Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: %i( new create )

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: %i( show )
    resources :posts, only: %i( show new create ) do
      resources :comments, only: %i( create destroy )
    end
    resources :votes, only: [] do
      put "upvote"
    end

    resources :collections, only: %i( index show new create edit update destroy )

    root to: "groups#show", as: :group_root
  end

  get "/frontend/posts" => "frontend#posts"
  get "/frontend/sign_up" => "frontend#sign_up"

  root to: "dashboard#index"
end
