class ApplicationController < ActionController::Base

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :num_of_day
  # before_action :number_of_day_calculation
  before_action :forbidden_action_60_days


  # before_action :require_payment, except: :color_mode_action, except: :linguibafa


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:city_id, :email, :phone, :password).merge(paid_until: 24.hours.from_now)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:city_id, :email, :phone, :password, :current_password)}
  end

  def num_of_day
    @number_of_lunar_day = Trunk.number_of_lunar_day
    @forbidden_action = Trunk.forbidden_action
  end

   def number_of_day_calculation(city, date)
    if date.month < 3
      mon = date.mon + 12
      year = date.year - 1
      else
      mon = date.mon
      year = date.year
    end
    number_of_day = (((mon + 1)) * 30.6).truncate  + (year * 365.25).truncate + date.day - 114
  end


  def forbidden_action_60_days
    city = current_doctor.city
    date = DateTime.current.in_time_zone(current_doctor.city.time_zone)
    day_num = number_of_day_calculation(city, date) % 60
    case day_num
    when 1, 31
      @message = 'Большой палец стопы'
    when 2, 32
      @message = 'Наружная лодыжка'
    when 3, 33
      @message = 'Внутренняя поверхность бедра'
    when 4, 34
      @message = 'Поясница'
    when 5, 35
      @message = 'Рот'
    when 6, 36
      @message = 'Кулак(кисть)'
    when 7, 37
      @message = 'Внутренняя лодыжка'
    when 8, 38
      @message = 'Внутренняя поверхность запястья'
    when 9, 39
      @message = 'Ягодицы и копчик'
    when 10, 40
      @message = 'Спина и поясница'
    when 11, 41
      @message = 'Спинка носа'
    when 12, 42
      @message = 'Наружная лодыжка'
    when 13, 43
      @message = 'Зубы и челюсти'
    when 14, 44
      @message = 'Эпигастрий, область желудка'
    when 15, 45
      @message = 'Все туловище'
    when 16, 46
      @message = 'Межреберья'
    when 17, 47
      @message = "Точка #{Point.find_by(name: 'Qi-chong')}"
    when 18, 48
      @message = 'Внутренняя поверхность бедра'
    when 19, 49
      @message = 'Стопы'
    when 20, 50
      @message = 'Внутренняя лодыжка'
    when 21, 51
      @message = 'Мизинцы рук'
    when 22, 52
      @message = 'Наружная лодыжка'
    when 23, 53
      @message = 'Стопы и область печени'
    when 24, 54
      @message = 'Ян- и Инь-каналы рук'
    when 25, 55
      @message = "Меридиан #{Meridian.find_by(name: 'Stomach')}"
    when 26, 56
      @message = 'Грудь'
    when 27, 57
      @message = 'Колени'
    when 28, 58
      @message = 'Наружные половые органы'
    when 29, 59
      @message = 'Задняя поверхность коленей и голеней'
    when 30, 60
      @message = 'Область предплюсневых костей стопы'
    else
      @message = 'Ошибка в методе '
    end
  end


end
