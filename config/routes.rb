Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # Newsletters
  resources :newsletter_users, only: [:create]
  get '/newsletter/unsubscribe/:newsletter_user_id/:token', to: 'newsletter_users#unsubscribe', as: :unsubscribe

  localized do
    root 'homes#index'
    resources :abouts, only: [:index, :show], concerns: :paginatable do
      resources :comments, only: [:create, :destroy]
    end
    resources :contacts, only: [:index, :new, :create]
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    get 'feed', to: 'posts#feed', as: :posts_rss

    get '/newsletter/welcome_user/:newsletter_user_id/:token', to: 'newsletters#welcome_user', as: :welcome_user
    get '/newsletter/:id/:newsletter_user_id/:token', to: 'newsletters#show', as: :show_newsletter
  end
end
