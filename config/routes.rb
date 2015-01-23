Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: %i( new create )

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: %i( show )
    resources :posts, only: %i( show new create )

    root to: "groups#show", as: :group_root
  end

  get "/frontend/posts" => "frontend#posts"

  root to: "dashboard#index"
end
