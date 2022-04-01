Rails.application.routes.draw do
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

  post 'vote', to: 'votes#vote', as: 'votes'

  root to: 'questions#index'
end
