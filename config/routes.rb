# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :users do
    resources :questions, shallow: true do
      resources :answers, shallow: true do
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
end
