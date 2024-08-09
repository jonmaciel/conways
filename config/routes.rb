# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boards, only: %i[index show create] do
    resources :generations, only: %i[index show]
    post 'next_generation', to: 'generations#next_generation'
  end
end
