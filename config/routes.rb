Rails.application.routes.draw do
	get '/doctors/index'
  get 'doctors/linguibafa'
  get 'doctors/infusion'
  get 'doctors/naganfa'
  root 'doctors#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
