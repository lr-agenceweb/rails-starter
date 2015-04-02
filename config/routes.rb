Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  localized do
    root 'homes#index'
    resources :abouts, only: [:index]
    resources :contacts, only: [:index, :new, :create]
  end
end
