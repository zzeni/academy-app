Rails.application.routes.draw do
  resources :courses do
    resources :students, only: :index
    post :attend, on: :member
    get :active, on: :collection
  end
  resources :categories, except: :destroy do
    resources :courses, only: :index
  end
  resources :students do
    resources :courses, only: :index
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'courses#index'
end
