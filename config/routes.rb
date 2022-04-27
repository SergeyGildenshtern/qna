require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        put :update_best
      end
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
  resources :comments, only: %i[create]

  post 'vote', to: 'votes#vote', as: 'votes'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :other, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end
end
