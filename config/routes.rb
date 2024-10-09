# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :users do
    resources :questions, shallow: true do
      member do
        delete :remove_file
      end
      resources :answers, shallow: true do
        member do
          patch :mark_as_best
        end
      end
    end
  end
end
