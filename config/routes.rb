Rails.application.routes.draw do
  devise_for :students
  resources :students do
    resources :courses, only: :index
    post :add, on: :collection
  end
  resources :courses do
    resources :students, only: :index
    post :attend, on: :member
    post :exit, on: :member
  end
  resources :categories, except: :destroy do
    resources :courses, only: :index
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'courses#index'
end
