Rails.application.routes.draw do
  devise_for :doctors
  get 'points/linguibafa'
  get 'points/infusion'
  get 'points/infusion_2'
  get 'points/naganfa'
  get 'points/complex_balance'
  get 'points/linguibafa_7_times'
  get 'points/infusion_7_times'
  get 'points/naganfa_7_times'
  get 'points/methods_mix'
  get 'points/wu_yun_liu_thi'
  get 'points/wu_yun_liu_thi_trunk'
  get 'points/show_point', to: 'points#show_point'
  get 'points/change_color'
  get 'points/lunar_palaces'
  root 'patients#index'
  get 'patients/color_mode_route',  to: 'patients#color_mode_action',  as: :color_mode_helper



  resources :points
  resources :doctors
  resources :patients
  resources :visits
  resources :layers
  resources :meridians
  resources :branches
  resources :truncs
  resources :trunks

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :doctors, :points, :patients, :visits, :layers, :meridians, :branches, :trunks
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
