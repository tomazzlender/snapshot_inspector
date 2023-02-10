Rails.application.routes.draw do
  root to: "pages#home"
  get "about", to: "pages#about", as: :about
  get "privacy", to: "pages#privacy", as: :privacy

  resources :users, only: [:index, :edit]
  resources :items, only: [:index, :show, :create]
end
