Rails.application.routes.draw do
  devise_for :doctors
  get 'points/linguibafa'
  get 'points/infusion'
  get 'points/naganfa'
  root 'patients#index'
  resources :points
  resources :doctors
  resources :patients


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
