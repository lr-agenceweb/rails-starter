Rails.application.routes.draw do
  get 'mailing_user/unsubscribe'

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :searchable do
    get '(/:term)', action: :index, on: :collection, as: ''
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy]
  end

  get 'robots.:format', to: 'robots#index'

  #
  # == Translated routes
  #
  localized do
    root 'homes#index'

    resources :homes, only: [:easter_egg] do
      get 'easter-egg', to: 'homes#easter_egg', on: :collection, as: :easter_egg # Easter egg
    end

    resources :abouts, only: [:index, :show], concerns: [:paginatable, :commentable]
    resources :legal_notices, only: [:index]
    resources :contacts, only: [:index, :new, :create]
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    # GuestBook
    resources :guest_books, only: [:index, :create], concerns: :paginatable

    # Blog
    resources :blogs, only: [:index, :show], concerns: [:paginatable, :commentable]

    # Search
    resources :searches, only: [:index], concerns: [:paginatable] do
      get 'autocomplete', on: :collection
    end

    # Event
    resources :events, only: [:index, :show], concerns: [:paginatable]

    # RSS
    get 'feed', to: 'posts#feed', as: :posts_rss

    # Newsletters
    get '/newsletter/welcome_user/:newsletter_user_id/:token', to: 'newsletters#welcome_user', as: :welcome_user
    get '/newsletter/:id/:newsletter_user_id/:token', to: 'newsletters#see_in_browser', as: :see_in_browser_newsletter
    get '/newsletter_user/unsubscribe/:newsletter_user_id/:token', to: 'newsletter_users#unsubscribe', as: :unsubscribe
    get '/admin/newsletters/:id/preview', to: 'admin/letters#preview', as: :preview_newsletter

    # Mailings
    get '/mailing_messages/:id/:token/:mailing_user_id/:mailing_user_token', to: 'mailing_messages#preview_in_browser', as: :preview_in_browser_mailing_message
    get '/admin/mailing_messages/:id/preview', to: 'admin/mailing_messages#preview', as: :preview_mailing_message
    get '/mailing_user/unsubscribe/:id/:token', to: 'mailing_users#unsubscribe', as: :unsubscribe_mailing_user


    # Mapbox popup content
    get 'contact/mapbox-popup', to: 'contacts#mapbox_popup', as: :mapbox_popup

    # Errors
    %w( 404 422 500 ).each do |code|
      get "/#{code}", to: 'errors#show', code: code, as: "error_#{code}".to_sym
    end
  end

  # Newsletters
  resources :newsletter_users, only: [:create]
  get '/admin/newsletters/:id/send', to: 'admin/letters#send_newsletter', as: :send_newsletter_for_subscribers
  get '/admin/newsletter_test/:id/send', to: 'admin/letters#send_newsletter_test', as: :send_newsletter_for_testers

  # Mailings
  get '/admin/mailing_messages/:id/:token/send', to: 'admin/mailing_messages#send_mailing_message', as: :send_mailing_message
end
