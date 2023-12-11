# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  resources :table_charts, only: :index
end
