Rails.application.routes.draw do
  get 'comments/create'

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  localized do
    root 'homes#index'
    resources :abouts, only: [:index, :show], concerns: :paginatable do
      resources :comments, only: [:create]
    end
    resources :contacts, only: [:index, :new, :create]
    resources :contact_forms, controller: 'contacts', only: [:index, :new, :create]

    get 'feed', to: 'posts#feed', as: :posts_rss
  end
end
