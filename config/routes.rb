require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobmonitor'

  scope :api, defaults: { format: :json } do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: '/users', controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions',
        passwords: 'api/v1/passwords',
        token_validations: 'api/v1/token_validations'
      }, skip: %i[omniauth_callbacks registrations]
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :user, only: %i[show update]
      resources :foods, only: %i[index show]

      resources :orders, only: %i[index create show]
      resources :line_items, only: %i[create show destroy]
      resources :discounts, only: %i[index show]

      get 'current_cart' => 'carts#show', as: :show_current_cart
      patch 'current_cart/empty' => 'carts#empty', as: :empty_current_cart

      patch 'line_items/:id/increase' => 'line_items#increment', as: :line_item_increase
      patch 'line_items/:id/reduce' => 'line_items#decrement', as: :line_item_reduce

      namespace :shopkeeper do
        resources :foods, only: %i[index create show update destroy]
        resources :discounts, only: %i[index show create update destroy]
        resources :orders, only: %i[index show update]
      end

      devise_scope :user do
        resources :users, only: [] do
          controller :registrations do
            post :create, on: :collection
          end
        end
      end
    end
  end
end
