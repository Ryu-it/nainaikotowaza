Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homes#index"

  resources :proverbs do
    resources :comments, only: %i[create destroy]
    resources :reactions, only: %i[create destroy]
  end

  resources :comments, only: [] do
    resources :reactions, only: %i[create destroy]
  end

  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end
    resource :follows, only: %i[create destroy]
  end

  resources :notifications, only: %i[index]

  resources :rooms, only: %i[new create] do
    resources :proverbs, only: %i[new create edit update], module: :rooms
  end

  resources :messages, only: %i[index]

  # スリープ対策のルーティング
  get "health", to: "health#show"

  # InvitationのURLヘルパーメソッド用ルーティング
  get "invitations/accept", to: "invitations#accept", as: :accept_invitation

  # aiで言葉かことわざを作成するルーティング
  namespace :ai do
    post :generate_words,   to: "words#generate"
    post :generate_proverb, to: "proverbs#generate"
  end
end
