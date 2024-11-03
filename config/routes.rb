Rails.application.routes.draw do
  root "home#index"
  get "home/index"

  resources :categories
  resources :enrollments
  # resources :questions
  resources :options
  resources :quiz_participations
  resources :reviews

  resources :courses do
    resources :lessons do
      member do
        post :mark_as_watched
      end
    end
    resources :payments
    resources :quizzes do
      resources :questions, shallow: true
    end
  end

  resources :users do
    collection do
      get "login"
      get "pending"
    end
    member do
      get 'confirmation/:token', to: 'users#confirm', as: 'confirmation'
      get "become_teacher"
      post "approve_teacher"
      post "reject_teacher"
      post "remove_profile_picture"
    end
  end

  resources :sessions do
    collection do
      get "login"
      get "logout"
      post "attempt_login"
      get "attempt_logout"
    end
  end
  resources :password_resets, only: [:new, :create, :edit, :update]

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
