Rails.application.routes.draw do

  root to: "questions#index"

  devise_for :users

  resources :users, shallow: true do
    resources :questions, shallow: true do
      resources :answers, shallow: true
    end
  end
end
