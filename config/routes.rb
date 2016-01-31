Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :searchable do
    get '(/:term)', action: :index, on: :collection, as: ''
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy] do
      member do
        get 'reply/:token', action: :reply, as: :reply
        get 'signal/:token', action: :signal, as: :signal
      end
    end
  end

  #
  # == Translated routes
  #
  localized do
    root 'homes#index'

    resources :abouts, only: [:index, :show], concerns: [:paginatable, :commentable]
    resources :legal_notices, only: [:index]
    resources :contacts, only: [:index, :new, :create] do
      # Mapbox popup content
      get 'mapbox-popup', action: :mapbox_popup, as: :mapbox_popup, on: :collection
    end
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    # GuestBook
    resources :guest_books, only: [:index, :create], concerns: :paginatable

    # Blog
    resources :blogs, only: [:index, :show], concerns: [:paginatable, :commentable]

    # Comment
    resources :comments, only: [] do
      get 'signal', on: :member
    end

    # Search
    resources :searches, only: [:index], concerns: [:paginatable] do
      get 'autocomplete', on: :collection
    end

    # Event
    resources :events, only: [:index, :show], concerns: [:paginatable]

    # RSS
    get 'feed', to: 'posts#feed', as: :posts_rss

    # Mailings (users)
    resources :mailing_users do
      get 'unsubscribe/:token', action: :unsubscribe, as: :unsubscribe, on: :member
    end

    # Mailings (messages)
    resources :mailing_messages do
      get ':token/:mailing_user_id/:mailing_user_token', action: :preview_in_browser, as: :preview_in_browser, on: :member
    end

    # Newsletters (users)
    get '/newsletter_user/unsubscribe/:newsletter_user_id/:token', to: 'newsletter_users#unsubscribe', as: :unsubscribe

    # Newsletters (messages)
    resources :newsletters do
      get ':newsletter_user_id/:token', action: :preview_in_browser, as: :preview_in_browser, on: :member
      get 'welcome_user/:newsletter_user_id/:token', action: :welcome_user, as: :welcome_user, on: :collection
    end

    namespace :admin do
      # Mailings (messages)
      resources :mailing_messages do
        get 'preview', action: :preview, as: :preview, on: :member
      end

      # Newsletters (messages)
      resources :newsletters do
        get 'preview', action: :preview, as: :preview, on: :member
      end
    end

    # Errors
    %w( 404 422 500 ).each do |code|
      get "/#{code}", to: 'errors#show', code: code, as: "error_#{code}".to_sym
    end
  end

  # Robots
  get 'robots.:format', to: 'robots#index'

  # Newsletters
  resources :newsletter_users, only: [:create]

  # Mailings (messages)
  namespace :admin do
    resources :mailing_messages do
      member do
        get ':token/send', action: :send_mailing_message, as: :send
      end
    end

    resources :newsletters do
      member do
        get 'send', action: :send_newsletter, as: :send
      end
    end
  end
end
