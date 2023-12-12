# frozen_string_literal: true

Rails.application.routes.draw do
  # root "articles#index"

  namespace :hero do
    namespace :banner do
      resources :images, only: %i[index create destroy]
    end
  end

  namespace :admin do
    resources :users, only: %i[index update]
  end

  resources :users, only: %i[create update]
  resources :sessions, only: %i[create destroy]
  resource :password_reset, only: %i[create edit update]
end
