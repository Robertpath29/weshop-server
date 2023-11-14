# frozen_string_literal: true

Rails.application.routes.draw do
  # root "articles#index"

  namespace :hero do
    namespace :banner do
      resources :images, only: %i[index create destroy]
    end
  end
end
