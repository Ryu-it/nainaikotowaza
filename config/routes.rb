Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  # スリープ対策用エンドポイント
  get "health", to: "health#show"
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # OGP画像
  get "images/ogp.png", to: "images#ogp", as: :images_ogp

  controller :static_pages do
    get :term
    get :privacy
    get :usage
  end

  root "homes#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  get "invitations/accept", to: "invitations#accept", as: :accept_invitation

  # Resources
  resources :proverbs do
    resources :comments, only: %i[create destroy]
    resources :reactions, only: %i[create destroy]
  end

  resources :comments, only: [] do
    resources :reactions, only: %i[create destroy]
  end

  resources :users, only: %i[index show] do
    member { get :following, :followers }
    resource :follows, only: %i[create destroy]
  end

  resources :notifications, only: %i[index]

  resources :rooms, only: %i[new create index] do
    resources :proverbs, only: %i[new create edit update], module: :rooms
  end

  resources :messages, only: %i[index]
  resources :rankings, only: %i[index]

  # AI
  namespace :ai do
    post :generate_words, to: "words#generate"
    get :generate_proverb, to: "proverbs#generate"
  end

  # Dev only
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
