Rails.application.routes.draw do
  root "clients#index"

  resources :clients

  namespace :api do
    namespace :v1 do
      resources :clients, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
