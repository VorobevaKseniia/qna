# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :users do
    resources :questions, shallow: true do
      resources :answers, shallow: true
    end
  end
end
