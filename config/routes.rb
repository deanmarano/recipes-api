Rails.application.routes.draw do
  resources :users
  use_doorkeeper
  resources :meals
  resources :recipes do
    collection do
      post :import
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
