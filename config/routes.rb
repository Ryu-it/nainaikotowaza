Rails.application.routes.draw do
  devise_for :users, controllers: {
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

  resources :proverbs

  resources :users, only: %i[index] do
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

  # InvitationのURLヘルパーメソッド用ルーティング
  get "invitations/accept", to: "invitations#accept", as: :accept_invitation

  # aiで言葉かことわざを作成するルーティング
  post "/ai/generate_words",   to: "ai#generate_words"   # 単語2つを生成
  post "/ai/generate_proverb", to: "ai#generate_proverb" # 単語を参照して ことわざ/意味/用例 を生成
end
