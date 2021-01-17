class ApplicationController < ActionController::Base

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :num_of_day
  before_action :trunc_day_show
  before_action :branch_day_show
  before_action :forbidden_action_60_days



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

  def trunc_day_calculation(city, date)
    trunc_day = number_of_day_calculation(city, date) % 10
    if trunc_day > 4
      trunc_day -= 4
      else
      trunc_day += 6
    end
  end

  def branch_day_calculation(city, date)
    branch_day = number_of_day_calculation(city, date) % 12
    if branch_day < 3
      branch_day += 10
    elsif branch_day == 0
      branch_day = 12
      else
      branch_day -= 2
    end
  end

  def trunc_day_show
    if current_doctor
      city = current_doctor.city
      date = DateTime.current.in_time_zone(current_doctor.city.time_zone)
      trunk = Trunk.find(trunc_day_calculation(city, date))
      @trunk_today = trunk.id
      @forbidden_action_by_days = trunk.forbidden_action_by_days
      @trunk_energy = trunk.trunk_energy
      @trunk_meridian = trunk.year_meridian.alias_ru
    end
  end

  def branch_day_show
    if current_doctor
      city = current_doctor.city
      date = DateTime.current.in_time_zone(current_doctor.city.time_zone)
      @branch_day = Branch.find(branch_day_calculation(city, date)).id
      case @branch_day
        when 1
          @forbidden_action_by_branch = 'Область глаз'
        when 2
          @forbidden_action_by_branch = 'Уши'
        when 3
          @forbidden_action_by_branch = 'Грудная клетка'
        when 4
          @forbidden_action_by_branch = 'Челюсти и зубы'
        when 5
          @forbidden_action_by_branch = 'Поясница'
        when 6
          @forbidden_action_by_branch = 'Руки'
        when 7
          @forbidden_action_by_branch = 'Область сердца'
        when 8
          @forbidden_action_by_branch = 'Стопы'
        when 9
          @forbidden_action_by_branch = 'Голова'
        when 10
          @forbidden_action_by_branch = 'Колени'
        when 11
          @forbidden_action_by_branch = 'Промежность'
        when 12
          @forbidden_action_by_branch = 'Передняя поверхность шеи'
        else
          @forbidden_action_by_branch = 'Ошибка в методе branch_day_show'
      end
    end
  end

  def forbidden_action_60_days
    if current_doctor
      city = current_doctor.city
      date = DateTime.current.in_time_zone(current_doctor.city.time_zone)
      day_num = number_of_day_calculation(city, date) % 60
      case day_num
        when 1, 31
          @forbidden_action_60_days = 'Большой палец стопы'
        when 2, 32
          @forbidden_action_60_days = 'Наружная лодыжка'
        when 3, 33
          @forbidden_action_60_days = 'Внутренняя поверхность бедра'
        when 4, 34
          @forbidden_action_60_days = 'Поясница'
        when 5, 35
          @forbidden_action_60_days = 'Рот'
        when 6, 36
          @forbidden_action_60_days = 'Кулак(кисть)'
        when 7, 37
          @forbidden_action_60_days = 'Внутренняя лодыжка'
        when 8, 38
          @forbidden_action_60_days = 'Внутренняя поверхность запястья'
        when 9, 39
          @forbidden_action_60_days = 'Ягодицы и копчик'
        when 10, 40
          @forbidden_action_60_days = 'Спина и поясница'
        when 11, 41
          @forbidden_action_60_days = 'Спинка носа'
        when 12, 42
          @forbidden_action_60_days = 'Наружная лодыжка'
        when 13, 43
          @forbidden_action_60_days = 'Зубы и челюсти'
        when 14, 44
          @forbidden_action_60_days = 'Эпигастрий, область желудка'
        when 15, 45
          @forbidden_action_60_days = 'Все туловище'
        when 16, 46
          @forbidden_action_60_days = 'Межреберья'
        when 17, 47
          @forbidden_action_60_days = "Точка #{Point.find_by(name: 'Qi-chong')}"
        when 18, 48
          @forbidden_action_60_days = 'Внутренняя поверхность бедра'
        when 19, 49
          @forbidden_action_60_days = 'Стопы'
        when 20, 50
          @forbidden_action_60_days = 'Внутренняя лодыжка'
        when 21, 51
          @forbidden_action_60_days = 'Мизинцы рук'
        when 22, 52
          @forbidden_action_60_days = 'Наружная лодыжка'
        when 23, 53
          @forbidden_action_60_days = 'Стопы и область печени'
        when 24, 54
          @forbidden_action_60_days = 'Ян- и Инь-каналы рук'
        when 25, 55
          @forbidden_action_60_days = "Меридиан #{Meridian.find_by(name: 'Stomach')}"
        when 26, 56
          @forbidden_action_60_days = 'Грудь'
        when 27, 57
          @forbidden_action_60_days = 'Колени'
        when 28, 58
          @forbidden_action_60_days = 'Наружные половые органы'
        when 29, 59
          @forbidden_action_60_days = 'Задняя поверхность коленей и голеней'
        when 30, 60
          @forbidden_action_60_days = 'Область предплюсневых костей стопы'
        else
          @forbidden_action_60_days = 'Ошибка в методе forbidden_action_60_days'
        end

      if [29, 41].include?(day_num)
        @forbidden_acu_day_60_days = 'Не лучший день для мужчин по 60-дневному циклу'
        elsif [22, 51, 52].include?(day_num)
          @forbidden_acu_day_60_days = 'Не лучший день для женщин по 60-дневному циклу'
        elsif [8, 42, 43, 44].include?(day_num)
          @forbidden_acu_day_60_days = 'Не лучший день для мужчин и женщин по 60-дневному циклу'
        else
        @forbidden_acu_day_60_days = 'Все хорошо, колите, доктор, колите'
      end
    end
  end


end
