Rails.application.routes.draw do
  devise_for :doctors
  get 'points/linguibafa'
  get 'points/infusion'
  get 'points/infusion_2'
  get 'points/naganfa'
  get 'points/complex_balance'
  get 'points/linguibafa_7_times'
  root 'patients#index'
  resources :points
  resources :doctors
  resources :patients
  resources :visits


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
