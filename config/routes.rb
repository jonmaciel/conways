# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boards, only: %i[create] do
    post 'next_generation', to: 'generations#next_generation'
  end
end
