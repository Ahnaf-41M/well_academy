Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all

  get "/assets/*path", to: lambda { |_| [ 404, {}, [] ] }
  # get '/packs/*path', to: lambda { |_| [404, {}, []] } # if using webpacker

  scope "(:locale)", locale: /en|bn/ do
    root "home#index"
    scope controller: :home do
      get :search
    end
    get "unauthorized", to: "errors#unauthorized"

    resources :categories
    resources :enrollments
    resources :quiz_participations
    resources :errors do
      collection do
        get :unauthorized
        get :not_found
      end
    end

    resources :courses do
      collection do
        get "index_by_category/:category_id", action: :index_by_category, as: :index_by_category
        get "enrollments", action: :enrollments
      end
      resources :lessons do
        member do
          post :mark_as_watched
        end
      end
      resources :quizzes do
        collection do
          get "dashboard"
        end
        member do
          get "start"
          post "submit"
        end
        resources :questions, shallow: true
      end
      resources :payments
      resources :reviews
    end

    resources :users do
      collection do
        get "login"
        get "pending"
      end
      member do
        get "confirmation/:token", to: "users#confirm", as: "confirmation"
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
    resources :password_resets, only: [ :new, :create, :edit, :update ], param: :reset_password_token

    get "up" => "rails/health#show", as: :rails_health_check
    get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

    match "*path", to: "errors#not_found", via: :all, constraints: ->(req) do
      !req.path.start_with?("/rails/active_storage/")
    end
  end

  match "*path", to: redirect("/#{I18n.default_locale}/%{path}"),
        constraints: lambda { |req|
          path = req.path
          !path.starts_with?("/#{I18n.default_locale}/") &&
            !path.starts_with?("/404") &&
            !path.starts_with?("/500") &&
            !path.starts_with?("/422") &&
            !path.start_with?("/rails/active_storage") &&
            !path.start_with?("/rails/blobs") &&
            !path.start_with?("/rails/representations") &&
            !path.start_with?("/rails/disk") &&
            !path.match?(/\A\/assets\/.*/) &&
            !path.match?(/\A\/packs\/.*/)
        },
        via: :all
end
