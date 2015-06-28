Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  optional_modules = Object.const_defined?('OptionalModule') ? OptionalModule.all : []
  comment_enabled = optional_modules.empty? ? true : optional_modules.by_name('Comment').enabled?
  guest_book_enabled = optional_modules.empty? ? true : optional_modules.by_name('GuestBook').enabled?
  search_enabled = optional_modules.empty? ? true : optional_modules.by_name('Search').enabled?
  newsletter_enabled = optional_modules.empty? ? true : optional_modules.by_name('Newsletter').enabled?
  rss_enabled = optional_modules.empty? ? true : optional_modules.by_name('RSS').enabled?

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :searchable do
    get '(/:query)', action: :index, on: :collection, as: ''
  end

  #
  # == Translated routes
  #
  localized do
    root 'homes#index'
    resources :abouts, only: [:index, :show], concerns: :paginatable do
      resources :comments, only: [:create, :destroy] if comment_enabled
    end
    resources :contacts, only: [:index, :new, :create]
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    # GuestBook
    if guest_book_enabled
      resources :guest_books, only: [:index, :create], concerns: :paginatable
    end

    # Search
    if search_enabled
      resources :searches, only: [:index], concerns: [:searchable, :paginatable]
    end

    # RSS
    get 'feed', to: 'posts#feed', as: :posts_rss if rss_enabled

    # Newsletters
    if newsletter_enabled
      get '/newsletter/welcome_user/:newsletter_user_id/:token', to: 'newsletters#welcome_user', as: :welcome_user
      get '/newsletter/:id/:newsletter_user_id/:token', to: 'newsletters#see_in_browser', as: :see_in_browser_newsletter
      get '/newsletter_user/unsubscribe/:newsletter_user_id/:token', to: 'newsletter_users#unsubscribe', as: :unsubscribe
      get '/admin/newsletters/:id/preview', to: 'admin/newsletters#preview', as: :preview_newsletter
    end
  end

  get 'robots.:format', to: 'robots#index'

  # Newsletters
  if newsletter_enabled
    resources :newsletter_users, only: [:create]
    get '/admin/newsletters/:id/send', to: 'admin/newsletters#send_newsletter', as: :send_newsletter_for_subscribers
    get '/admin/newsletter_test/:id/send', to: 'admin/newsletters#send_newsletter_test', as: :send_newsletter_for_testers
  end

  # GuestBook
  if guest_book_enabled
    get 'toggle_guest_book_validated/:id', to: 'admin/guest_books#toggle_guest_book_validated', as: :toggle_guest_book_validated
  end
end
