Rails.application.routes.draw do
  devise_for :users

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: %i( show new create )
    resources :posts, only: %i( show new create )

    root to: 'groups#show', as: :group_root
  end

  root to: 'dashboard#index'
end
