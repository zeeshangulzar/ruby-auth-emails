Rails.application.routes.draw do
  devise_for :users

  get "dashboard" => "home#dashboard", as: :dashboard

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
