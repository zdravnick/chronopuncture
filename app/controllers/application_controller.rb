class ApplicationController < ActionController::Base

def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :password, :password_confirmation, :email) }
  end


end
