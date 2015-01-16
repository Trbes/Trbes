Rails.application.routes.draw do
  devise_for :users

  constraints(subdomain: SubdomainValidator::REG_EXP) do
    resources :groups, only: [:show]

    root to: 'groups#show', as: :group_root
  end

  authenticated :user do
    resources :groups, only: [:new, :create]

    root to: 'user/dashboard#index', as: :user_root
  end

  root to: 'dashboard#index'
end
