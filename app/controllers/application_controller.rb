class ApplicationController < ActionController::Base

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_payment, except: :color_mode_action


  def require_payment
    return if doctor_signed_in? == false
    return if controller_name.in?(%w[sessions registrations])  || (controller_name == 'pages' && action_name == 'pay')
    return if current_doctor&.has_paid? || current_doctor&.moderator?

    redirect_to pages_pay_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:city_id, :email, :phone, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:city_id, :email, :phone, :password, :current_password)}
  end

end
