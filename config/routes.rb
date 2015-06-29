Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :searchable do
    get '(/:query)', action: :index, on: :collection, as: ''
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy]
  end

  #
  # == Translated routes
  #
  localized do
    root 'homes#index'
    resources :abouts, only: [:index, :show], concerns: [:paginatable, :commentable]
    resources :contacts, only: [:index, :new, :create]
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    # GuestBook
    resources :guest_books, only: [:index, :create], concerns: :paginatable

    # Blog
    resources :blogs, only: [:index, :show], concerns: [:paginatable, :commentable]

    # Search
    resources :searches, only: [:index], concerns: [:searchable, :paginatable]

    # RSS
    get 'feed', to: 'posts#feed', as: :posts_rss

    # Newsletters
    get '/newsletter/welcome_user/:newsletter_user_id/:token', to: 'newsletters#welcome_user', as: :welcome_user
    get '/newsletter/:id/:newsletter_user_id/:token', to: 'newsletters#see_in_browser', as: :see_in_browser_newsletter
    get '/newsletter_user/unsubscribe/:newsletter_user_id/:token', to: 'newsletter_users#unsubscribe', as: :unsubscribe
    get '/admin/newsletters/:id/preview', to: 'admin/newsletters#preview', as: :preview_newsletter
  end

  get 'robots.:format', to: 'robots#index'

  # Newsletters
  resources :newsletter_users, only: [:create]
  get '/admin/newsletters/:id/send', to: 'admin/newsletters#send_newsletter', as: :send_newsletter_for_subscribers
  get '/admin/newsletter_test/:id/send', to: 'admin/newsletters#send_newsletter_test', as: :send_newsletter_for_testers

  # GuestBook
  get 'toggle_guest_book_validated/:id', to: 'admin/guest_books#toggle_guest_book_validated', as: :toggle_guest_book_validated
end
