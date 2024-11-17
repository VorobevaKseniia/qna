# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :searches, only: [:index], constraints: { scope: /all|questions|answers|comments|users/ }

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :users do
    resources :questions, concerns: [:commentable], shallow: true do
      resources :subscriptions, only: %i[create destroy]
      resources :answers, concerns: [:commentable], shallow: true do
        member do
          patch :mark_as_best
        end
      end
    end
    resources :awards, only: :index
  end
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :votes, only: [] do
    collection do
      post :vote
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  mount ActionCable.server => '/cable'
end
