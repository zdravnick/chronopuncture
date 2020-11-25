class PointsController < ApplicationController


  around_action :set_time_zone

  before_action :prepare


  skip_before_action :prepare, only: [:show_point]
  skip_before_action :prepare, only: [:change_color]
  skip_before_action :prepare, only: [:show_point_of_meridian]
  skip_before_action :prepare, only: [:lunar_palaces]
  skip_before_action :prepare, only: [:wu_yun_liu_thi_trunk]

  def show_point
    @point = Point.all.find(params[:id])
    render 'points/show'
  end


  def change_color
    if params["wood"].to_i == 1
      @change_color = "red"
      else
      @change_color = "#ffb3b3"
    end
  end


  def set_time_zone(&block)
    Time.use_zone(current_doctor.city.time_zone, &block)
  end

  def prepare
    @doctor_city = current_doctor.city
    @doctor_current_datetime_utc = Time.zone.local(params["date(1i)"].to_i,
      params["date(2i)"].to_i,params["date(3i)"].to_i,
      params["date(4i)"].to_i,params["date(5i)"].to_i).in_time_zone('UTC')
    @sun_time = sun_time(@doctor_city, @doctor_current_datetime_utc)
    @sun_datetime_zone =
      ActiveSupport::TimeZone[current_doctor.city.time_zone].local(@sun_time.year, @sun_time.month, @sun_time.day, @sun_time.hour, @sun_time.min, @sun_time.sec)
    @trunc_day = trunc_day_calculation(@doctor_city, @sun_datetime_zone)
    @offset_timezone_doctor =
      (@doctor_current_datetime_utc.in_time_zone(current_doctor.city.time_zone) - @sun_datetime_zone).to_i
    @brunch_day = brunch_day_calculation(@doctor_city, @sun_datetime_zone)
    @trunc_hour = trunc_hour_calculation(@doctor_city, @sun_datetime_zone)
    @brunch_hour = brunch_hour_calculation(@doctor_city, @sun_datetime_zone)
    @guard = guard(@doctor_city, @sun_datetime_zone)
    @eot = eot(@sun_datetime_zone).to_i
    @offset_for_time_table =
      (@doctor_current_datetime_utc.in_time_zone(current_doctor.city.time_zone) - @sun_time).to_i
  end

  def lunar_palaces
    @lunarpalace =
      LunarPalace.new(year: params["date"].values[2].to_i, month: params["date"].values[1].to_i, day:params["date"].values[0].to_i)
    @lunar_palaces_year_num = @lunarpalace.lunar_palaces_year_num
    @lunar_palaces_month_num = @lunarpalace.lunar_palaces_month_num
    @lunar_palace_opposite = @lunarpalace.lunar_palace_opposite
    @points_of_lunar_palaces = @lunarpalace.points_of_lunar_palaces
    render "doctors/lunar_palaces"
  end

  def linguibafa
    @sum_of_numbers_linguibafa =
      sum_of_numbers_linguibafa(@doctor_city, @sun_datetime_zone)
    @opened_points_linguibafa =
      opened_point_linguibafa(@doctor_city, @sun_datetime_zone)
      @tie_point_linguibafa =
      tie_point_linguibafa(@doctor_city, @sun_datetime_zone)
    render  "doctors/linguibafa"
  end

  def linguibafa_7_times
  @opened_points_linguibafa =
    (@sun_datetime_zone.to_datetime..@sun_datetime_zone.to_datetime+6.days).map do |date|
      @sum_of_numbers_linguibafa =
      sum_of_numbers_linguibafa(@doctor_city, date)
    {date: date, point: opened_point_linguibafa(@doctor_city, date) }
    end
     @tie_points_linguibafa =
    (@sun_datetime_zone.to_datetime..@sun_datetime_zone.to_datetime+6.days).map do |date|
      @sum_of_numbers_linguibafa =
      sum_of_numbers_linguibafa(@doctor_city, date)
    {date: date, tie_point: tie_point_linguibafa(@doctor_city, date) }
    end

  end

  helper_method :opened_point_linguibafa
  helper_method :tie_point_linguibafa
  helper_method :opened_points_naganfa
  helper_method :opened_points_infusion_2
  helper_method :sun_time
  helper_method :sun_time_difference
  helper_method :slider

  def slider

  end

  def infusion
    @points_infusion = points_infusion
    @opened_points_infusion = opened_points_infusion(@trunc_day, @guard, @points_infusion)
    render "doctors/infusion"
    # There is SUN TIME in the table!
  end

  def infusion_7_times
    @infusion_start_day = @doctor_current_datetime_utc.at_beginning_of_day.to_datetime
    @points_infusion = points_infusion_2
    @opened_points_infusion = ((@infusion_start_day)..@doctor_current_datetime_utc.end_of_day.to_datetime+6.days).map do |date|
      @trunc_day = trunc_day_calculation(@doctor_city, date)
      guard_infusion_7.map do |guard|
        {date: date, point: opened_points_infusion_2(@trunc_day, guard, @points_infusion) }
        end
    end
  end

  def methods_mix
    @infusion_start_day = @doctor_current_datetime_utc.at_beginning_of_day.to_datetime
    @points_infusion = points_infusion_2
    @opened_points = ((@infusion_start_day)..@doctor_current_datetime_utc.end_of_day.to_datetime+6.days).map do |date|
      @trunc_day = trunc_day_calculation(@doctor_city, date)
      guard_infusion_7.map do |guard|
        {
          date: date,
          point: opened_points_infusion_2(@trunc_day, guard, @points_infusion),
          linguibafa: opened_point_linguibafa(@doctor_city, date)
        }
        end
    end
  end


  def infusion_2
    @points_infusion = points_infusion_2
    @opened_points_infusion = opened_points_infusion_2(@trunc_day, @guard, @points_infusion)
    render "_infusion_2"
    # There is SUN TIME in the table!
  end

  def naganfa
    # binding.pry
    @mark = time_mark(@doctor_current_datetime_utc)
    @points_naganfa = points_naganfa
    @opened_points_naganfa =
      opened_points_naganfa(@trunc_day, @mark, @points_naganfa, @doctor_current_datetime_utc)
    render "doctors/naganfa"
    # There is TIME.now in the table!
  end

  def naganfa_7_times
    @mark = time_mark(@doctor_current_datetime_utc)
    @points_naganfa = points_naganfa
    @date = ((@doctor_current_datetime_utc.to_datetime)..@doctor_current_datetime_utc.to_datetime+6.days).to_a
    @opened_points_naganfa = @date.map do |date|
      @trunc_day = trunc_day_calculation(@doctor_city, date)
      {date: date, points: opened_points_naganfa(@trunc_day, @mark, @points_naganfa, date)
      }
  end
    # There is TIME.now in the table!
  end

  # def wu_yun_liu_thi
  #   @patient = Patient.find(params["patient_id"])
  #   @patient_city = @patient.city
  #   @guard_doctor = guard(@doctor_city, @sun_datetime_zone )
  #   Time.use_zone(@patient.city.time_zone) do
  #     @patient_birthdate = Time.zone.local(params["birthdate(1i)"].to_i,
  #       params["birthdate(2i)"].to_i,params["birthdate(3i)"].to_i,
  #       params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i)
  #     @patient_birthdate_utc = @patient_birthdate.in_time_zone('UTC')
  #     @full_layer = Layer.all.full_layer_wu_yun(@patient_birthdate_utc.to_date)
  #     @empty_layer_name = Layer.all.empty_layer_wu_yun_table(@full_layer)
  #     @empty_layer = (@empty_layer_name.map do |elem|
  #       Layer.all.empty_layer_wu_yun(elem)
  #       end
  #       )
  #     @full_trunc_year =
  #       Trunc.trunc_year_wu_yun_definition(@patient_birthdate_utc.to_date)[:value]
  #     @empty_trunc_year = Trunc.empty_trunc_year_wu_yun_definition(@full_trunc_year)
  #     @full_branch_year = Branch.full_branch_year_wu_yun(@patient_birthdate_utc)
  #     @empty_branch_year = Branch.empty_branch_year_wu_yun(@full_branch_year)
  #     @base_star_wu_yun =  [ 'Wood', 'Fire', 'Earth', 'Metal', 'Water' ]
  #     @star_5_energies_wu_yun =
  #       [ @full_layer.leg_meridian_element, @full_layer.arm_meridian_element,
  #         @full_trunc_year.element, @full_trunc_year.year_meridian.energy_name,
  #         @full_branch_year.day_meridian.energy_name
  #       ]
  #     @star_season_energies_wu_yun =
  #       [
  #         @full_layer.leg_meridian.element_branch , @full_layer.arm_meridian.element_branch ,
  #         @full_trunc_year.year_meridian.element_branch, @full_branch_year.day_meridian.element_branch
  #       ]

  #     @star_5_energies_wu_yun_remainder = @base_star_wu_yun - @star_5_energies_wu_yun
  #     @star_5_energies_wu_yun_remainder_meridians = Meridian.where(energy_name: @star_5_energies_wu_yun_remainder)

  #     @star_season_energies_wu_yun_remainder = @base_star_wu_yun - @star_season_energies_wu_yun
  #     @star_season_energies_wu_yun_remainder_meridians = Meridian.where(element_branch: @star_season_energies_wu_yun_remainder)

  #     @ids = @star_5_energies_wu_yun_remainder_meridians.map(&:id) & @star_season_energies_wu_yun_remainder_meridians.map(&:id)
  #     @missing_energies_meridians = Meridian.where(id: @ids)

  #   end
  #   render "doctors/wu_yun_liu_thi"
  # end

  def wu_yun_liu_thi_trunk
    @patient = Patient.find(params["patient_id"])
    @patient_city = @patient.city
    # @guard_doctor = guard(@doctor_city, @sun_datetime_zone )
    Time.use_zone(@patient.city.time_zone) do
      @patient_birthdate = Time.zone.local(params["birthdate(1i)"].to_i,
        params["birthdate(2i)"].to_i,params["birthdate(3i)"].to_i,
        params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i)
      @patient_birthdate_utc = @patient_birthdate.in_time_zone('UTC')
      @full_layer = Layer.all.full_layer_wu_yun(@patient_birthdate_utc.to_date)
      @empty_layer_name = Layer.all.empty_layer_wu_yun_table(@full_layer)
      @empty_layer = (@empty_layer_name.map do |elem|
        Layer.all.empty_layer_wu_yun(elem)
        end
        )
      @full_trunk_year =
        Trunk.trunk_year_wu_yun_definition(@patient_birthdate_utc.to_date)[:value]
      @empty_trunk_year = Trunk.empty_trunk_year_wu_yun_definition(@full_trunk_year)
      @full_branch_year = Branch.full_branch_year_wu_yun(@patient_birthdate_utc)
      @empty_branch_year = Branch.empty_branch_year_wu_yun(@full_branch_year)
      @base_star_wu_yun =  [ 'Wood', 'Fire', 'Earth', 'Metal', 'Water' ]
      @star_5_energies_wu_yun =
        [ @full_layer.leg_meridian_element, @full_layer.arm_meridian_element,
          @full_trunk_year.trunk_energy, @full_trunk_year.year_meridian.energy_name,
          @full_branch_year.day_meridian.energy_name
        ]
      @star_season_energies_wu_yun =
        [
          @full_layer.leg_meridian.element_branch , @full_layer.arm_meridian.element_branch ,
          @full_trunk_year.year_meridian.element_branch, @full_branch_year.day_meridian.element_branch
        ]

      @star_5_energies_wu_yun_remainder = @base_star_wu_yun - @star_5_energies_wu_yun
      @star_5_energies_wu_yun_remainder_meridians = Meridian.where(energy_name: @star_5_energies_wu_yun_remainder)

      @star_season_energies_wu_yun_remainder = @base_star_wu_yun - @star_season_energies_wu_yun
      @star_season_energies_wu_yun_remainder_meridians = Meridian.where(element_branch: @star_season_energies_wu_yun_remainder)

      @ids = @star_5_energies_wu_yun_remainder_meridians.map(&:id) & @star_season_energies_wu_yun_remainder_meridians.map(&:id)
      @missing_energies_meridians = Meridian.where(id: @ids)
      @change_color = change_color
    end
    render "doctors/wu_yun_liu_thi_trunk"
  end

  def complex_balance
    @patient = Patient.find(params["patient_id"])
    @patient_city = @patient.city
    @guard_doctor = guard(@doctor_city, @sun_datetime_zone )
    Time.use_zone(@patient.city.time_zone) do
      @patient_birthdate = Time.zone.local(params["birthdate(1i)"].to_i,
        params["birthdate(2i)"].to_i,params["birthdate(3i)"].to_i,
        params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i)
      @patient_birthdate_utc = @patient_birthdate.in_time_zone('UTC')
      @year_num_patient = year_number_60th_calculation(@patient_birthdate)
      @number_of_day_60th = number_of_day__60th_cycle_calculation(@year_num_patient,
          @patient_birthdate)
      @sun_time_patient = sun_time(@patient_city, @patient_birthdate_utc)
      @eot_patient = eot_patient(@sun_time_patient)
      @guard_patient = guard_patient(@sun_time_patient.hour)
      @month_patient_lo_shu = patient_month_calculation(@patient_birthdate)[:value]
      @first_point_lo_shu = first_point_lo_shu_number(@year_num_patient, @month_patient_lo_shu,
        @number_of_day_60th, @guard_doctor)
      @hour = sun_time( @doctor_city, @doctor_current_datetime_utc).hour
      @min = sun_time( @doctor_city, @doctor_current_datetime_utc).min
      # получасие активного на момент приема пацика Канала
      @half_hour_visit = half_hour_for_reception_time(hour: @hour, min: @min)
      # выбор Таблицы Меридиана для заполнения квадрата Ло Шу
      @meridian_lo_shu = meridian_for_lo_shu_square(@half_hour_visit)
      @matrix = points_matrix_lo_shu(@meridian_lo_shu)
      @opened_points_lo_shu = lo_shu_points(@matrix, @first_point_lo_shu)[:points]
      render "doctors/complex_balance"
    end
  end

  def guard_infusion_7
    guard = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end


  def eot(date)
    pi = (Math::PI) # pi
    delta = (date.getutc.yday - 1) # (Текущий день года - 1)

    yy = date.getutc.year
    np = case yy #The number np is the number of days from 1 January to the date of the Earth's perihelion. (http://www.astropixels.com/ephemeris/perap2001.html)
          when 1921, 1929, 1937, 1945, 1970, 1978, 1989, 1997 ; 0
          when 1923, 1924, 1926, 1932, 1934, 1935, 1940, 1942, 1943, 1946, 1948, 1951, 1953, 1954,
                     1956, 1959, 1961, 1962, 1964, 1965, 1967, 1973, 1975, 1981, 1983, 1986, 1994, 2002,
                     2005, 2008, 2013, 2016, 2021, 2029, 2043  ; 1
          when 1920, 1922, 1925, 1927, 1930, 1931, 1933, 1938, 1939, 1941, 1949, 1950, 1957, 1958,
                     1966, 1969, 1972, 1977, 1980, 1984, 1985, 1988, 1991, 1992, 1999, 2000, 2007, 2010,
                     2011, 2018, 2019, 2024, 2026, 2027, 2030, 2032, 2035, 2037, 2038, 2040, 2041, 2045,
                     2046, 2048, 2049  ; 2
          when 1928, 1936, 1944, 1947, 1952, 1955, 1960, 1963, 1968, 1971, 1974, 1976, 1979, 1982,
                     1987, 1990, 1993, 1995, 1996, 1998, 2001, 2003, 2004, 2006, 2009, 2014, 2015, 2017,
                     2022, 2023, 2025, 2031, 2033, 2034, 2042, 2050 ; 3
          when 2012, 2020, 2028, 2036, 2039, 2044, 2047 ; 4
          else ; 2
          end

    a = date.getutc.to_a; delta = delta + a[2].to_f / 24 + a[1].to_f / 60 / 24 # Поправка на дробную часть дня

    lambda = 23.4406 * pi / 180; # Earth's inclination in radians
    omega = 2 * pi / 365.2564 # angular velocity of annual revolution (radians/day)
    alpha = omega * ((delta + 10) % 365) # angle in (mean) circular orbit, solar year starts 21. Dec
    beta = alpha + 0.03340560188317 * Math.sin(omega * ((delta - np) % 365)) # angle in elliptical orbit, from perigee  (radians)
    gamma = (alpha - Math.atan(Math.tan(beta) / Math.cos(lambda))) / pi # angular correction

    eot = (43200 * (gamma - gamma.round)) # equation of time in seconds
  end

  def sun_time(city, date)
      # case city[:lng]
      # when (0..15) then base_meridian = 15
      # when (16..30) then base_meridian = 30
      # when (31..45) then base_meridian = 45
      # when (46..60) then base_meridian = 60
      # when (61..75) then base_meridian = 75
      # when (76..90) then base_meridian = 90
      # when (91..105) then base_meridian = 105
      # when (106..120) then base_meridian = 120
      # when (121..135) then base_meridian = 135
      # when (136..150) then base_meridian = 150
      # when (151..165) then base_meridian = 165
      # when (166..180) then base_meridian = 180

      # end
      # base = base_meridian*4.minutes
    date + (city[:lng]*4).minutes + eot(date).seconds
  end

  def sun_time_difference(city, date)
    (city[:lng]*4).minutes + eot(date).seconds
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

  def brunch_day_calculation(city, date)
    brunch_day = number_of_day_calculation(city, date) % 12
    if brunch_day < 3
      brunch_day += 10
    elsif brunch_day == 0
      brunch_day = 12
      else
      brunch_day -= 2
    end
  end

  def brunch_hour_calculation(city, time)
    case time.hour
    when 19..20 then 11
    when 21..22 then 12
    when 23 then 1
    when 0 then 1
    when  1..2 then 2
    when  3..4 then 3
    when  5..6 then 4
    when  7..8 then 5
    when  9..10 then 6
    when 11..12 then 7
    when 13..14 then 8
    when 15..16 then 9
    when 17..18 then 10
    end
  end

  def guard(city, date) # таблица Стражи Часа
    case date.hour
    when 19, 20 then 11
    when 21, 22 then 12
    when 23, 0 then 1
    when  1, 2 then 2
    when  3, 4 then 3
    when  5, 6 then 4
    when  7, 8 then 5
    when  9, 10 then 6
    when 11, 12 then 7
    when 13, 14 then 8
    when 15, 16 then 9
    when 17, 18 then 10
    end
  end


  def trunc_hour_calculation(city, date)
    trunc_hour = (guard(city, date) + ((trunc_day_calculation(city, date) - 1) * 2))%10
    if trunc_hour == 0
      trunc_hour = 10
    else
      trunc_hour
    end

    # if Date.current.leap?
    #   trunc_hour += 1
    # end
  end

  def trunc_day_definition_linguibafa(city, date) # таблица соответствия условного числа стволу дня
    case trunc_day_calculation(city, date)
    when 1, 6 then 10
    when 2, 7 then 9
    when 4, 9 then 8
    when 3, 5, 8, 10 then 7
    end
  end

  def brunch_day_definition_linguibafa(city, date) # таблица соответствия числа ветви дня
    case brunch_day_calculation(city, date)
    when 2, 5, 8, 11 then 10
    when 9, 10 then 9
    when 3, 4 then 8
    when 1, 6, 7, 12 then 7
    end
  end

  def trunc_hour_definition_linguibafa(city, date)
    case trunc_hour_calculation(city, date)
    when 1, 6 then 9
    when 2, 7 then 8
    when 3, 8 then 7
    when 4, 9 then 6
    when 5, 10 then 5
    end
  end

  def brunch_hour_definition_linguibafa(city, date)
    case guard(city, date)
    when 1, 7 then 9
    when 2, 8 then 8
    when 3, 9 then 7
    when 4, 10 then 6
    when 5, 11 then 5
    when 6, 12 then 4
    end
  end

  def sum_of_numbers_linguibafa(city, date)
    trunc_day_definition_linguibafa(city, date) + brunch_day_definition_linguibafa(city, date) +
    trunc_hour_definition_linguibafa(city, date) + brunch_hour_definition_linguibafa(city, date)
  end

  def divider_trunc_day(city, date) # выбор делителя для иньского/янского дня
    if trunc_day_calculation(city, date).even?
      6
    else
      9
    end
  end

  def remainder_of_division_linguibafa(city, date) # остаток от деления
    sum_of_numbers_linguibafa(city, date) % divider_trunc_day(city, date)
  end

  def opened_point_linguibafa(city, date) # таблица соответствия "расчетная цифра - точка"

    case remainder_of_division_linguibafa(city, date)
    when 1 then Point.find_by(alias_ru: 'Шэнь-май')
    when 2, 5 then Point.find_by(alias_ru: 'Чжао-хай')
    when 3 then Point.find_by(alias_ru: 'Вай-гуань')
    when 4 then Point.find_by(alias_ru: 'Цзу-линь-ци')
    when 6 then Point.find_by(alias_ru: 'Гунь-сунь')
    when 7 then Point.find_by(alias_ru: 'Хоу-си')
    when 8 then Point.find_by(alias_ru: 'Нэй-гуань')
    when 9 then Point.find_by(alias_ru: 'Ле-цюе')
    when 0
      if trunc_day_calculation(city, date).even?
        Point.find_by(alias_ru: 'Гунь-сунь')
      else
        Point.find_by(alias_ru: 'Ле-цюе')
      end
    end
  end

  def tie_point_linguibafa(city, date)
    case remainder_of_division_linguibafa(city, date)
    when 1 then Point.find_by(alias_ru: 'Хоу-си')
    when 2, 5 then Point.find_by(alias_ru: 'Ле-цюе')
    when 3 then Point.find_by(alias_ru: 'Цзу-линь-ци')
    when 4 then Point.find_by(alias_ru: 'Вай-гуань')
    when 6 then Point.find_by(alias_ru: 'Нэй-гуань')
    when 7 then Point.find_by(alias_ru: 'Шэнь-май')
    when 8 then Point.find_by(alias_ru: 'Гунь-сунь')
    when 9 then Point.find_by(alias_ru: 'Чжао-хай')
    when 0
      if trunc_day_calculation(city, date).even?
        Point.find_by(alias_ru: 'Нэй-гуань')
      else
        Point.find_by(alias_ru: 'Чжао-хай')
      end
    end
  end

    # END OF LINGUIBAFA METHOD
  def point_infusion_2
    {
      'FIRST GUARD  JIA GALL_BLADDER' => [
         Point.find_or_create_by(name: 'Vb.44'),
         Point.find_or_create_by(name: 'Ig.2'),
        [Point.find_or_create_by(name: 'E.43'), Point.find_or_create_by(name: 'Vb.40')],
         Point.find_or_create_by(name: 'Gi.5'),
         Point.find_or_create_by(name: 'V.40')
      ],  # GB

     '2nd GUARD YI LIVER' => [
          Point.find_or_create_by(name: 'F.1'),
          Point.find_or_create_by(name: 'C.8'),
         [Point.find_or_create_by(name: 'Rp.3'), Point.find_or_create_by(name: 'F.3')],
          Point.find_or_create_by(name: 'P.8'),
          Point.find_or_create_by(name: 'R.10')
        ],  # LIVER

        '3d GUARD BING SMALL INT' => [
          Point.find_or_create_by(name: 'Ig.1'),
          Point.find_or_create_by(name: 'E.44'),
         [Point.find_or_create_by(name: 'Gi.3'), Point.find_or_create_by(name: 'Ig.4')],
          Point.find_or_create_by(name: 'V.60'),
          Point.find_or_create_by(name: 'Vb.34')
        ], # SMALL INT

        '4th GUARD DIN HEART' => [
          Point.find_or_create_by(name: 'C.9'),
          Point.find_or_create_by(name: 'Rp.2'),
         [Point.find_or_create_by(name: 'P.9'), Point.find_or_create_by(name: 'C.7')],
          Point.find_or_create_by(name: 'R.7'),
          Point.find_or_create_by(name: 'F.8')
        ],  # HEART

        '5th GUARD WU STOMACH' => [
          Point.find_or_create_by(name: 'E.45'),
          Point.find_or_create_by(name: 'Gi.2'),
         [Point.find_or_create_by(name: 'V.65'), Point.find_or_create_by(name: 'E.42')],
          Point.find_or_create_by(name: 'Vb.38'),
          Point.find_or_create_by(name: 'Ig.8')
        ], # STOMACH

        '6th GUARD JI SPLEEN' => [
          Point.find_or_create_by(name: 'Rp.1'),
          Point.find_or_create_by(name: 'P.10'),
         [Point.find_or_create_by(name: 'R.3'), Point.find_or_create_by(name: 'Rp.3')],
          Point.find_or_create_by(name: 'F.4'),
          Point.find_or_create_by(name: 'C.3')
        ], # SPLEEN

        '7th GUARD GENG LARGE INT' => [
          Point.find_or_create_by(name: 'Gi.1'),
          Point.find_or_create_by(name: 'V.66'),
         [Point.find_or_create_by(name: 'Vb.41'), Point.find_or_create_by(name: 'Gi.4')],
          Point.find_or_create_by(name: 'Ig.5'),
          Point.find_or_create_by(name: 'E.36')
        ], # LARGE INT

        '8th XIN LUNGS' => [
          Point.find_or_create_by(name: 'P.11'),
          Point.find_or_create_by(name: 'R.2'),
         [Point.find_or_create_by(name: 'F.3'), Point.find_or_create_by(name: 'P.9')],
          Point.find_or_create_by(name: 'C.4'),
          Point.find_or_create_by(name: 'Rp.9')
        ], # LUNGS

        '9th GUARD REN BLADDER' => [
          Point.find_or_create_by(name: 'V.67'),
          Point.find_or_create_by(name: 'Vb.43'),
         [Point.find_or_create_by(name: 'Ig.3'), Point.find_or_create_by(name: 'V.64')],
          Point.find_or_create_by(name: 'E.41'),
          Point.find_or_create_by(name: 'Gi.11')
        ], # BLADDER

        '10th GUARD GUI KIDNEY' => [
          Point.find_or_create_by(name: 'R.1'),
          Point.find_or_create_by(name: 'F.2'),
         [Point.find_or_create_by(name: 'C.7'), Point.find_or_create_by(name: 'R.3')],
          Point.find_or_create_by(name: 'Rp.5'),
          Point.find_or_create_by(name: 'P.5')
        ], # GUI, 10 KIDNEY

        '11th GUARD MC ' => [
          Point.find_or_create_by(name: 'Mc.9'),
          Point.find_or_create_by(name: 'Mc.8'),
          Point.find_or_create_by(name: 'Mc.7'),
          Point.find_or_create_by(name: 'Mc.5'),
          Point.find_or_create_by(name: 'Mc.3')
        ], # MC  PERICARD

        '12th GUARD SAN JIAO' => [
          Point.find_or_create_by(name: 'Tr.1'),
          Point.find_or_create_by(name: 'Tr.2'),
         [Point.find_or_create_by(name: 'Tr.3'), Point.find_or_create_by(name: 'TR.4')],
          Point.find_or_create_by(name: 'Tr.6'),
          Point.find_or_create_by(name: 'Tr.10')
        ] # SAN JIAO

    }
  end

  def points_infusion
    points_infusion = [
    [], # for exept zero
    [
      'FIRST GUARD  JIA GALL_BLADDER',
      'Vb.44 Zu-qiao-yin',
      'Ig.2 Qian-gu',
      'E.43 Xian-gu' + ' and ' + 'Vb.40 Qiu-xu',
      'Gi.5 Yang-xi',
      'V.40 Wei-zhong'
    ], # GB

    [
      '2nd GUARD YI LIVER',
      'F.1 Da-dun',
      'C.8 Shao-fu',
      'Rp.3 Tai-bai' + ' and ' + 'F.3 Tai-chong',
      'P.8 Jing-qu',
      'R.10 Yin-gu'
    ],  # LIVER

    [
      '3d GUARD BING SMALL INT',
      'Ig.1 Shao-ze',
      'E.44 Nei-ting',
      'Gi.3 San-jian' + ' and ' + 'Ig.4 Wan-gu',
      'V.60 Kun-lun',
      'Vb.34 Yang-ling-quan'
    ],# SMALL INT

    [
      '4th GUARD DIN HEART',
      'C.9 Shao-chong',
      'Rp.2 Da-du',
      'P.9 Tai-yuan' + ' and ' + 'C.7 Shen-men',
      'R.7 Fu-liu',
      'F.8 Qu-quan'
    ], # HEART

    [
      '5th GUARD WU STOMACH',
      'E.45 Li-dui',
      'Gi.2 Er-jian',
      'V.65 Shu-gu' + ' and ' + 'E.42 Chong-yang',
      'Vb.38 Yang-fu',
      'Ig.8 Xiao-hai'
    ], # STOMACH

    [
      '6th GUARD JI SPLEEN',
      'Rp.1 Yin-bai',
      'P.10 Yu-zi',
      'R.3 Tai-xi' + ' and ' + 'Rp.3 Tai-bai',
      'F.4 Zhong-feng',
      'C.3 Shao-xai'
    ], # SPLEEN

    [ '7th GUARD  GENG LARGE INT',
      'Gi.1 Shang-yang',
      'V.66 Zu-tong-gu',
      'Vb.41 Zu-lin-qi' + ' and ' + 'Gi.4 He-gu',
      'Ig.5 Yang-gu',
      'E.36 Zu-san-li'
    ], # LARGE INT

    [
      '8th XIN LUNGS',
      'P.11 Shao-shang',
      'R.2 Jan-gu',
      'F.3 Tai-chong' + ' and ' + 'P.9 Tai-yuan',
      'C.4 Ling-dao',
      'Rp.9 Yin-ling-quan'
    ], # LUNGS

    [ '9th GUARD REN BLADDER',
      'V.67 Zhi-yin',
      'Vb.43 Xia-xi',
      'Ig.3 Hou-xi' + ' and ' + 'V.64 Jing-gu',
      'E.41 Jie-xi',
      'Gi.11 Qu-chi'
    ], # BLADDER
    [
      '10th GUARD GUI KIDNEY',
      'R.1 Yong-quan',
      'F.2 Xing-jian',
      'C.7 Shen-men' + ' and ' +  'R.3 Tai-xi',
      'Rp.5 Shang-qiu',
      'P.5 Chi-ze'
    ], # GUI, 10 KIDNEY

    [ '11th GUARD MC ',
      'Mc.9 Zhong-chong',
      'Mc.8 Lao-gong',
      'Mc.7 Da-ling',
      'Mc.5 Jian-shi',
      'Mc.3 Qu-ze'
    ], # MC  PERICARD

    [
      '12th GUARD SAN JIAO',
      'Tr.1 Guan-chong',
      'Tr.2 Ye-men',
      'Tr.3 Zhong-zhu' + ' and ' +  'TR.4 Yang-chi',
      'Tr.6 Zhi-gou',
      'Tr.10 Tian-jing'
    ] # SAN JIAO
    ]
  end
  # method infusion_2 with Model Points

  def points_infusion_2
    {
      'FIRST GUARD  JIA GALL_BLADDER' => [
         Point.find_or_create_by(name: 'Vb.44'),
         Point.find_or_create_by(name: 'Ig.2'),
        [Point.find_or_create_by(name: 'E.43'), Point.find_or_create_by(name: 'Vb.40')],
         Point.find_or_create_by(name: 'Gi.5'),
         Point.find_or_create_by(name: 'V.40')
      ],  # GB

      '2nd GUARD YI LIVER' => [
          Point.find_or_create_by(name: 'F.1'),
          Point.find_or_create_by(name: 'C.8'),
         [Point.find_or_create_by(name: 'Rp.3'), Point.find_or_create_by(name: 'F.3')],
          Point.find_or_create_by(name: 'P.8'),
          Point.find_or_create_by(name: 'R.10')
        ],  # LIVER

        '3d GUARD BING SMALL INT' => [
          Point.find_or_create_by(name: 'Ig.1'),
          Point.find_or_create_by(name: 'E.44'),
         [Point.find_or_create_by(name: 'Gi.3'), Point.find_or_create_by(name: 'Ig.4')],
          Point.find_or_create_by(name: 'V.60'),
          Point.find_or_create_by(name: 'Vb.34')
        ], # SMALL INT

        '4th GUARD DIN HEART' => [
          Point.find_or_create_by(name: 'C.9'),
          Point.find_or_create_by(name: 'Rp.2'),
         [Point.find_or_create_by(name: 'P.9'), Point.find_or_create_by(name: 'C.7')],
          Point.find_or_create_by(name: 'R.7'),
          Point.find_or_create_by(name: 'F.8')
        ],  # HEART

        '5th GUARD WU STOMACH' => [
          Point.find_or_create_by(name: 'E.45'),
          Point.find_or_create_by(name: 'Gi.2'),
         [Point.find_or_create_by(name: 'V.65'), Point.find_or_create_by(name: 'E.42')],
          Point.find_or_create_by(name: 'Vb.38'),
          Point.find_or_create_by(name: 'Ig.8')
        ], # STOMACH

        '6th GUARD JI SPLEEN' => [
          Point.find_or_create_by(name: 'Rp.1'),
          Point.find_or_create_by(name: 'P.10'),
         [Point.find_or_create_by(name: 'R.3'), Point.find_or_create_by(name: 'Rp.3')],
          Point.find_or_create_by(name: 'F.4'),
          Point.find_or_create_by(name: 'C.3')
        ], # SPLEEN

        '7th GUARD GENG LARGE INT' => [
          Point.find_or_create_by(name: 'Gi.1'),
          Point.find_or_create_by(name: 'V.66'),
         [Point.find_or_create_by(name: 'Vb.41'), Point.find_or_create_by(name: 'Gi.4')],
          Point.find_or_create_by(name: 'Ig.5'),
          Point.find_or_create_by(name: 'E.36')
        ], # LARGE INT

        '8th XIN LUNGS' => [
          Point.find_or_create_by(name: 'P.11'),
          Point.find_or_create_by(name: 'R.2'),
         [Point.find_or_create_by(name: 'F.3'), Point.find_or_create_by(name: 'P.9')],
          Point.find_or_create_by(name: 'C.4'),
          Point.find_or_create_by(name: 'Rp.9')
        ], # LUNGS

        '9th GUARD REN BLADDER' => [
          Point.find_or_create_by(name: 'V.67'),
          Point.find_or_create_by(name: 'Vb.43'),
         [Point.find_or_create_by(name: 'Ig.3'), Point.find_or_create_by(name: 'V.64')],
          Point.find_or_create_by(name: 'E.41'),
          Point.find_or_create_by(name: 'Gi.11')
        ], # BLADDER

        '10th GUARD GUI KIDNEY' => [
          Point.find_or_create_by(name: 'R.1'),
          Point.find_or_create_by(name: 'F.2'),
         [Point.find_or_create_by(name: 'C.7'), Point.find_or_create_by(name: 'R.3')],
          Point.find_or_create_by(name: 'Rp.5'),
          Point.find_or_create_by(name: 'P.5')
        ], # GUI, 10 KIDNEY

        '11th GUARD MC' => [
          Point.find_or_create_by(name: 'Mc.9'),
          Point.find_or_create_by(name: 'Mc.8'),
          Point.find_or_create_by(name: 'Mc.7'),
          Point.find_or_create_by(name: 'Mc.5'),
          Point.find_or_create_by(name: 'Mc.3')
        ], # MC  PERICARD

        '12th GUARD SAN JIAO' => [
          Point.find_or_create_by(name: 'Tr.1'),
          Point.find_or_create_by(name: 'Tr.2'),
         [Point.find_or_create_by(name: 'Tr.3'), Point.find_or_create_by(name: 'TR.4')],
          Point.find_or_create_by(name: 'Tr.6'),
          Point.find_or_create_by(name: 'Tr.10')
        ] # SAN JIAO
    }
  end

  def opened_points_infusion(trunc_day, guard, points_infusion)
    result = []
    case trunc_day
    when 1
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[1][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[1][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[1][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[1][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[8][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[11][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[11][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[11][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[11][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[11][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[2][5] + ' is opened'
      end
    when 2
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[3][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[3][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[3][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[3][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[10][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[12][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[12][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[12][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[12][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[12][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[2][5] + ' is opened'
          elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[4][5] + ' is opened'
      end
    when 3
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[5][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[5][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[5][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[5][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[11][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[11][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[11][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[11][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[11][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[6][5] + ' is opened'
      end
    when 4
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[7][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[7][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[7][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[7][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[12][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[12][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[12][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[12][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[12][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[4][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[6][5] + ' is opened'
          elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[8][5] + ' is opened'
      end
    when 5
      if guard == 1
          result <<  '23:00 - 23:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '23:24 - 23:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '23:48 - 00:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '00:12 - 00:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '00:36 - 00:59 ' + points_infusion[9][5] + ' is opened'
          elsif guard == 2
            result <<  '01:00 - 01:23 ' + points_infusion[10][1] + ' is opened'
            result <<  '01:24 - 01:47 ' + points_infusion[10][2] + ' is opened'
            result <<  '01:48 - 02:11 ' + points_infusion[10][3] + ' is opened'
            result <<  '02:12 - 02:35 ' + points_infusion[10][4] + ' is opened'
            result <<  '02:36 - 02:59 ' + points_infusion[10][5] + ' is opened'
          elsif guard == 3
            result <<  '03:00 - 03:23 ' + points_infusion[1][1] + ' is opened'
            result <<  '03:24 - 03:47 ' + points_infusion[1][2] + ' is opened'
            result <<  '03:48 - 04:11 ' + points_infusion[1][3] + ' is opened'
            result <<  '04:11 - 04:35 ' + points_infusion[1][4] + ' is opened'
            result <<  '04:36 - 04:59 ' + points_infusion[1][5] + ' is opened'
          elsif guard == 4
            result <<  '05:00 - 05:23 ' + points_infusion[2][1] + ' is opened'
            result <<  '05:24 - 05:47 ' + points_infusion[2][2] + ' is opened'
            result <<  '05:48 - 06:11 ' + points_infusion[2][3] + ' is opened'
            result <<  '06:12 - 06:35 ' + points_infusion[2][4] + ' is opened'
            result <<  '06:36 - 06:59 ' + points_infusion[2][5] + ' is opened'
          elsif guard == 5
            result <<  '07:00 - 07:23 ' + points_infusion[3][1] + ' is opened'
            result <<  '07:24 - 07:47 ' + points_infusion[3][2] + ' is opened'
            result <<  '07:48 - 08:11 ' + points_infusion[3][3] + ' is opened'
            result <<  '08:12 - 08:35 ' + points_infusion[3][4] + ' is opened'
            result <<  '08:36 - 08:59 ' + points_infusion[3][5] + ' is opened'
          elsif guard == 6
            result <<  '09:00 - 09:23 ' + points_infusion[11][1] + ' is opened'
            result <<  '09:24 - 09:47 ' + points_infusion[11][2] + ' is opened'
            result <<  '09:48 - 10:11 ' + points_infusion[11][3] + ' is opened'
            result <<  '10:12 - 10:35 ' + points_infusion[11][4] + ' is opened'
            result <<  '10:36 - 10:59 ' + points_infusion[11][5] + ' is opened'
          elsif guard == 7
            result <<  '11:00 - 11:23 ' + points_infusion[5][1] + ' is opened'
            result <<  '11:24 - 11:47 ' + points_infusion[5][2] + ' is opened'
            result <<  '11:48 - 12:11 ' + points_infusion[5][3] + ' is opened'
            result <<  '12:12 - 12:35 ' + points_infusion[5][4] + ' is opened'
            result <<  '12:36 - 12:59 ' + points_infusion[5][5] + ' is opened'
          elsif guard == 8
            result <<  '13:00 - 13:23 ' + points_infusion[6][1] + ' is opened'
            result <<  '13:24 - 13:47 ' + points_infusion[6][2] + ' is opened'
            result <<  '13:48 - 14:11 ' + points_infusion[6][3] + ' is opened'
            result <<  '14:12 - 14:36 ' + points_infusion[6][4] + ' is opened'
            result <<  '14:37 - 14:59 ' + points_infusion[6][5] + ' is opened'
          elsif guard == 9
            result <<  '15:00 - 15:23 ' + points_infusion[7][1] + ' is opened'
            result <<  '15:24 - 15:47 ' + points_infusion[7][2] + ' is opened'
            result <<  '15:48 - 16:11 ' + points_infusion[7][3] + ' is opened'
            result <<  '16:12 - 16:35 ' + points_infusion[7][4] + ' is opened'
            result <<  '16:36 - 16:59 ' + points_infusion[7][5] + ' is opened'
          elsif guard == 10
            result <<  '17:00 - 17:23 ' + points_infusion[8][1] + ' is opened'
            result <<  '17:24 - 17:47 ' + points_infusion[8][2] + ' is opened'
            result <<  '17:48 - 18:11 ' + points_infusion[8][3] + ' is opened'
            result <<  '18:12 - 18:35 ' + points_infusion[8][4] + ' is opened'
            result <<  '18:36 - 18:59 ' + points_infusion[8][5] + ' is opened'
            elsif guard == 11
            result <<  '19:00 - 19:23 ' + points_infusion[9][1] + ' is opened'
            result <<  '19:24 - 19:47 ' + points_infusion[9][2] + ' is opened'
            result <<  '19:48 - 20:11 ' + points_infusion[9][3] + ' is opened'
            result <<  '20:12 - 20:35 ' + points_infusion[9][4] + ' is opened'
            result <<  '20:36 - 20:59 ' + points_infusion[9][5] + ' is opened'
          elsif guard == 12
            result <<  '21:00 - 21:23 ' + points_infusion[10][1] + ' is opened'
            result <<  '21:24 - 21:47 ' + points_infusion[10][2] + ' is opened'
            result <<  '21:48 - 22:11 ' + points_infusion[10][3] + ' is opened'
            result <<  '22:12 - 22:35 ' + points_infusion[10][4] + ' is opened'
            result <<  '22:36 - 22:59 ' + points_infusion[10][5] + ' is opened'
      end
    when 6
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[1][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[1][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[1][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[1][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[12][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[12][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[12][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[12][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[12][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[8][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[2][5] + ' is opened'
      end
    when 7
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[3][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[3][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[3][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[3][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[11][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[11][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[11][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[11][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[11][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[10][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[4][5] + ' is opened'
      end
    when 8
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[5][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[5][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[5][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[5][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[12][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[12][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[12][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[12][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[12][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[2][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[6][5] + ' is opened'
      end
    when 9
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[7][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[7][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[7][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[7][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[11][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[11][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[11][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[11][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[11][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[4][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[6][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '19:48 - 22:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '21:48 - 20:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[8][5] + ' is opened'
      end
    when 10
      if guard == 1
        result <<  '23:00 - 23:23 ' + points_infusion[12][1] + ' is opened'
        result <<  '23:24 - 23:47 ' + points_infusion[12][2] + ' is opened'
        result <<  '23:48 - 00:11 ' + points_infusion[12][3] + ' is opened'
        result <<  '00:12 - 00:35 ' + points_infusion[12][4] + ' is opened'
        result <<  '00:36 - 00:59 ' + points_infusion[12][5] + ' is opened'
        elsif guard == 2
          result <<  '01:00 - 01:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '01:24 - 01:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '01:48 - 02:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '02:12 - 02:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '02:36 - 02:59 ' + points_infusion[10][5] + ' is opened'
        elsif guard == 3
          result <<  '03:00 - 03:23 ' + points_infusion[1][1] + ' is opened'
          result <<  '03:24 - 03:47 ' + points_infusion[1][2] + ' is opened'
          result <<  '03:48 - 04:11 ' + points_infusion[1][3] + ' is opened'
          result <<  '04:11 - 04:35 ' + points_infusion[1][4] + ' is opened'
          result <<  '04:36 - 04:59 ' + points_infusion[1][5] + ' is opened'
        elsif guard == 4
          result <<  '05:00 - 05:23 ' + points_infusion[2][1] + ' is opened'
          result <<  '05:24 - 05:47 ' + points_infusion[2][2] + ' is opened'
          result <<  '05:48 - 06:11 ' + points_infusion[2][3] + ' is opened'
          result <<  '06:12 - 06:35 ' + points_infusion[2][4] + ' is opened'
          result <<  '06:36 - 06:59 ' + points_infusion[2][5] + ' is opened'
        elsif guard == 5
          result <<  '07:00 - 07:23 ' + points_infusion[3][1] + ' is opened'
          result <<  '07:24 - 07:47 ' + points_infusion[3][2] + ' is opened'
          result <<  '07:48 - 08:11 ' + points_infusion[3][3] + ' is opened'
          result <<  '08:12 - 08:35 ' + points_infusion[3][4] + ' is opened'
          result <<  '08:36 - 08:59 ' + points_infusion[3][5] + ' is opened'
        elsif guard == 6
          result <<  '09:00 - 09:23 ' + points_infusion[4][1] + ' is opened'
          result <<  '09:24 - 09:47 ' + points_infusion[4][2] + ' is opened'
          result <<  '09:48 - 10:11 ' + points_infusion[4][3] + ' is opened'
          result <<  '10:12 - 10:35 ' + points_infusion[4][4] + ' is opened'
          result <<  '10:36 - 10:59 ' + points_infusion[4][5] + ' is opened'
        elsif guard == 7
          result <<  '11:00 - 11:23 ' + points_infusion[5][1] + ' is opened'
          result <<  '11:24 - 11:47 ' + points_infusion[5][2] + ' is opened'
          result <<  '11:48 - 12:11 ' + points_infusion[5][3] + ' is opened'
          result <<  '12:12 - 12:35 ' + points_infusion[5][4] + ' is opened'
          result <<  '12:36 - 12:59 ' + points_infusion[5][5] + ' is opened'
        elsif guard == 8
          result <<  '13:00 - 13:23 ' + points_infusion[6][1] + ' is opened'
          result <<  '13:24 - 13:47 ' + points_infusion[6][2] + ' is opened'
          result <<  '13:48 - 14:11 ' + points_infusion[6][3] + ' is opened'
          result <<  '14:12 - 14:36 ' + points_infusion[6][4] + ' is opened'
          result <<  '14:37 - 14:59 ' + points_infusion[6][5] + ' is opened'
        elsif guard == 9
          result <<  '15:00 - 15:23 ' + points_infusion[7][1] + ' is opened'
          result <<  '15:24 - 15:47 ' + points_infusion[7][2] + ' is opened'
          result <<  '15:48 - 16:11 ' + points_infusion[7][3] + ' is opened'
          result <<  '16:12 - 16:35 ' + points_infusion[7][4] + ' is opened'
          result <<  '16:36 - 16:59 ' + points_infusion[7][5] + ' is opened'
        elsif guard == 10
          result <<  '17:00 - 17:23 ' + points_infusion[8][1] + ' is opened'
          result <<  '17:24 - 17:47 ' + points_infusion[8][2] + ' is opened'
          result <<  '17:48 - 18:11 ' + points_infusion[8][3] + ' is opened'
          result <<  '18:12 - 18:35 ' + points_infusion[8][4] + ' is opened'
          result <<  '18:36 - 18:59 ' + points_infusion[8][5] + ' is opened'
        elsif guard == 11
          result <<  '19:00 - 19:23 ' + points_infusion[9][1] + ' is opened'
          result <<  '19:24 - 19:47 ' + points_infusion[9][2] + ' is opened'
          result <<  '19:48 - 20:11 ' + points_infusion[9][3] + ' is opened'
          result <<  '20:12 - 20:35 ' + points_infusion[9][4] + ' is opened'
          result <<  '20:36 - 20:59 ' + points_infusion[9][5] + ' is opened'
        elsif guard == 12
          result <<  '21:00 - 21:23 ' + points_infusion[10][1] + ' is opened'
          result <<  '21:24 - 21:47 ' + points_infusion[10][2] + ' is opened'
          result <<  '21:48 - 22:11 ' + points_infusion[10][3] + ' is opened'
          result <<  '22:12 - 22:35 ' + points_infusion[10][4] + ' is opened'
          result <<  '22:36 - 22:59 ' + points_infusion[10][5] + ' is opened'
      end
    end
    return result
  end

  def opened_points_infusion_2(trunc_day, guard, points_infusion)
    result = []
    case trunc_day
      when 1
        if guard == 1
          meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
            result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
            result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
            result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
            result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '2nd GUARD YI LIVER'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '4th GUARD DIN HEART'
            result << { time: '05:00 - 05:23', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '5th GUARD WU STOMACH'
            result << { time: '07:00 - 07:23', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '6th GUARD JI SPLEEN'
            result <<  { time: '09:00 - 09:23', hour: 9, point: points_infusion[meridian][0] }
            result <<  { time: '09:24 - 09:47', hour: 9, point: points_infusion[meridian][1] }
            result <<  { time: '09:48 - 10:11', hour: 9, point: points_infusion[meridian][2] }
            result <<  { time: '10:12 - 10:35', hour: 9, point: points_infusion[meridian][3] }
            result <<  { time: '10:36 - 10:59', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '7th GUARD GENG LARGE INT'
            result <<  { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result <<  { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result <<  { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result <<  { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result <<  { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '8th XIN LUNGS'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '9th GUARD REN BLADDER'
            result << { time: '15:00 - 15:23', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '11th GUARD MC'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '2nd GUARD YI LIVER'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 2
        if guard == 1
          meridian = '3d GUARD BING SMALL INT'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '4th GUARD DIN HEART'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '5th GUARD WU STOMACH'
            result << { time: '03:00 - 03:23', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '6th GUARD JI SPLEEN'
            result <<  { time: '05:00 - 05:23', hour: 5, point: points_infusion[meridian][0] }
            result <<  { time: '05:24 - 05:47', hour: 5, point: points_infusion[meridian][1] }
            result <<  { time: '05:48 - 06:11', hour: 5, point: points_infusion[meridian][2] }
            result <<  { time: '06:12 - 06:35', hour: 5, point: points_infusion[meridian][3] }
            result <<  { time: '06:36 - 06:59', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '7th GUARD GENG LARGE INT'
            result <<  { time: '07:00 - 07:23', hour: 7, point: points_infusion[meridian][0] }
            result <<  { time: '07:24 - 07:47', hour: 7, point: points_infusion[meridian][1] }
            result <<  { time: '07:48 - 08:11', hour: 7, point: points_infusion[meridian][2] }
            result <<  { time: '08:12 - 08:35', hour: 7, point: points_infusion[meridian][3] }
            result <<  { time: '08:36 - 08:59', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '8th XIN LUNGS'
            result << { time: '09:00 - 09:23', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '9th GUARD REN BLADDER'
            result << { time: '11:00 - 11:23', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '13:00 - 13:23', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '12th GUARD SAN JIAO'
            result << { time: '15:00 - 15:23', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '2nd GUARD YI LIVER'
            result << { time: '17:00 - 17:23', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59', hour: 17, point: points_infusion[meridian][4] }
            elsif guard == 11
              meridian = '3d GUARD BING SMALL INT'
            result <<  { time: '19:00 - 19:23', hour: 19, point: points_infusion[meridian][0] }
            result <<  { time: '19:24 - 19:47', hour: 19, point: points_infusion[meridian][1] }
            result <<  { time: '19:48 - 20:11', hour: 19, point: points_infusion[meridian][2] }
            result <<  { time: '20:12 - 20:35', hour: 19, point: points_infusion[meridian][3] }
            result <<  { time: '20:36 - 20:59', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '4th GUARD DIN HEART'
            result << { time: '21:00 - 21:23', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59', hour: 21, point: points_infusion[meridian][4] }
        end
      when 3
        if guard == 1
          meridian = '5th GUARD WU STOMACH'
          result << { time: '23:00 - 23:23', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '01:00 - 01:23', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '03:00 - 03:23', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '8th XIN LUNGS'
            result << { time: '05:00 - 05:23', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '9th GUARD REN BLADDER'
            result << { time: '07:00 - 07:23', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '09:00 - 09:23', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result <<  { time: '11:00 - 11:23', hour: 11, point: points_infusion[meridian][0] }
            result <<  { time: '11:24 - 11:47', hour: 11, point: points_infusion[meridian][1] }
            result <<  { time: '11:48 - 12:11', hour: 11, point: points_infusion[meridian][2] }
            result <<  { time: '12:12 - 12:35', hour: 11, point: points_infusion[meridian][3] }
            result <<  { time: '12:36 - 12:59', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '11th GUARD MC'
            result << { time: '13:00 - 13:23', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '15:00 - 15:23', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:12 - 16:35', hour: 15, point: points_infusion[meridian][4] }
            result << { time: '16:36 - 16:59', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '4th GUARD DIN HEART'
            result << { time: '17:00 - 17:23', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:12 - 18:35', hour: 17, point: points_infusion[meridian][4] }
            result << { time: '18:36 - 18:59', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '5th GUARD WU STOMACH'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][4] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][4] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 4
        if guard == 1
          meridian = '7th GUARD GENG LARGE INT'
            result << { time: '23:00 - 23:23', hour: 23, point: points_infusion[meridian][0] }
            result << { time: '23:24 - 23:47', hour: 23, point: points_infusion[meridian][1] }
            result << { time: '23:48 - 00:11', hour: 23, point: points_infusion[meridian][2] }
            result << { time: '00:12 - 00:35', hour: 23, point: points_infusion[meridian][3] }
            result << { time: '00:36 - 00:59', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '8th XIN LUNGS'
            result << { time: '01:00 - 01:23', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '9th GUARD REN BLADDER'
            result << { time: '03:00 - 03:23', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '2nd GUARD YI LIVER'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '12th GUARD SAN JIAO'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '4th GUARD DIN HEART'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '5th GUARD WU STOMACH'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '8th XIN LUNGS'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 5
        if guard == 1
          meridian = '9th GUARD REN BLADDER'
            result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
            result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
            result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
            result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
            result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
            elsif guard == 2
              meridian = '10th GUARD GUI KIDNEY'
              result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
              result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
              result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
              result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
              result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
            elsif guard == 3
              meridian = 'FIRST GUARD  JIA GALL_BLADDER'
              result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
              result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
              result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
              result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
              result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
            elsif guard == 4
              meridian = '2nd GUARD YI LIVER'
              result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
              result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
              result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
              result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
              result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
            elsif guard == 5
              meridian = '3d GUARD BING SMALL INT'
              result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
              result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
              result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
              result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
              result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
            elsif guard == 6
              meridian = '11th GUARD MC'
              result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
              result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
              result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
              result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
              result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
            elsif guard == 7
              meridian = '5th GUARD WU STOMACH'
              result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
              result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
              result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
              result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
              result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
            elsif guard == 8
              meridian = '6th GUARD JI SPLEEN'
              result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
              result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
              result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
              result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
              result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
            elsif guard == 9
              meridian = '7th GUARD GENG LARGE INT'
              result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
              result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
              result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
              result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
              result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
            elsif guard == 10
              meridian = '8th XIN LUNGS'
              result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
              result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
              result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
              result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
              result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
              elsif guard == 11
                meridian = '9th GUARD REN BLADDER'
              result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
              result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
              result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
              result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
              result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
            elsif guard == 12
              meridian = '10th GUARD GUI KIDNEY'
              result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
              result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
              result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
              result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
              result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 6
        if guard == 1
          meridian = 'FIRST GUARD  JIA GALL_BLADDER'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '2nd GUARD YI LIVER'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian ='3d GUARD BING SMALL INT'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '4th GUARD DIN HEART'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '12th GUARD SAN JIAO'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '8th XIN LUNGS'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '9th GUARD REN BLADDER'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '2nd GUARD YI LIVER'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 7
        if guard == 1
          meridian = '3d GUARD BING SMALL INT'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '4th GUARD DIN HEART'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '5th GUARD WU STOMACH'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '11th GUARD MC'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '8th XIN LUNGS'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '9th GUARD REN BLADDER'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '2nd GUARD YI LIVER'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '4th GUARD DIN HEART'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 8
        if guard == 1
          meridian = '5th GUARD WU STOMACH'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '12th GUARD SAN JIAO'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '8th XIN LUNGS'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '9th GUARD REN BLADDER'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '2nd GUARD YI LIVER'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '4th GUARD DIN HEART'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '5th GUARD WU STOMACH'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 9
        if guard == 1
          meridian = '7th GUARD GENG LARGE INT'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '11th GUARD MC'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = '9th GUARD REN BLADDER'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '2nd GUARD YI LIVER'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '4th GUARD DIN HEART'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '5th GUARD WU STOMACH'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 22:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '8th XIN LUNGS'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 20:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
      when 10
        if guard == 1
          meridian = '12th GUARD SAN JIAO'
          result << { time: '23:00 - 23:23 ', hour: 23, point: points_infusion[meridian][0] }
          result << { time: '23:24 - 23:47 ', hour: 23, point: points_infusion[meridian][1] }
          result << { time: '23:48 - 00:11 ', hour: 23, point: points_infusion[meridian][2] }
          result << { time: '00:12 - 00:35 ', hour: 23, point: points_infusion[meridian][3] }
          result << { time: '00:36 - 00:59 ', hour: 23, point: points_infusion[meridian][4] }
          elsif guard == 2
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '01:00 - 01:23 ', hour: 1, point: points_infusion[meridian][0] }
            result << { time: '01:24 - 01:47 ', hour: 1, point: points_infusion[meridian][1] }
            result << { time: '01:48 - 02:11 ', hour: 1, point: points_infusion[meridian][2] }
            result << { time: '02:12 - 02:35 ', hour: 1, point: points_infusion[meridian][3] }
            result << { time: '02:36 - 02:59 ', hour: 1, point: points_infusion[meridian][4] }
          elsif guard == 3
            meridian = 'FIRST GUARD  JIA GALL_BLADDER'
            result << { time: '03:00 - 03:23 ', hour: 3, point: points_infusion[meridian][0] }
            result << { time: '03:24 - 03:47 ', hour: 3, point: points_infusion[meridian][1] }
            result << { time: '03:48 - 04:11 ', hour: 3, point: points_infusion[meridian][2] }
            result << { time: '04:11 - 04:35 ', hour: 3, point: points_infusion[meridian][3] }
            result << { time: '04:36 - 04:59 ', hour: 3, point: points_infusion[meridian][4] }
          elsif guard == 4
            meridian = '2nd GUARD YI LIVER'
            result << { time: '05:00 - 05:23 ', hour: 5, point: points_infusion[meridian][0] }
            result << { time: '05:24 - 05:47 ', hour: 5, point: points_infusion[meridian][1] }
            result << { time: '05:48 - 06:11 ', hour: 5, point: points_infusion[meridian][2] }
            result << { time: '06:12 - 06:35 ', hour: 5, point: points_infusion[meridian][3] }
            result << { time: '06:36 - 06:59 ', hour: 5, point: points_infusion[meridian][4] }
          elsif guard == 5
            meridian = '3d GUARD BING SMALL INT'
            result << { time: '07:00 - 07:23 ', hour: 7, point: points_infusion[meridian][0] }
            result << { time: '07:24 - 07:47 ', hour: 7, point: points_infusion[meridian][1] }
            result << { time: '07:48 - 08:11 ', hour: 7, point: points_infusion[meridian][2] }
            result << { time: '08:12 - 08:35 ', hour: 7, point: points_infusion[meridian][3] }
            result << { time: '08:36 - 08:59 ', hour: 7, point: points_infusion[meridian][4] }
          elsif guard == 6
            meridian = '4th GUARD DIN HEART'
            result << { time: '09:00 - 09:23 ', hour: 9, point: points_infusion[meridian][0] }
            result << { time: '09:24 - 09:47 ', hour: 9, point: points_infusion[meridian][1] }
            result << { time: '09:48 - 10:11 ', hour: 9, point: points_infusion[meridian][2] }
            result << { time: '10:12 - 10:35 ', hour: 9, point: points_infusion[meridian][3] }
            result << { time: '10:36 - 10:59 ', hour: 9, point: points_infusion[meridian][4] }
          elsif guard == 7
            meridian = '5th GUARD WU STOMACH'
            result << { time: '11:00 - 11:23 ', hour: 11, point: points_infusion[meridian][0] }
            result << { time: '11:24 - 11:47 ', hour: 11, point: points_infusion[meridian][1] }
            result << { time: '11:48 - 12:11 ', hour: 11, point: points_infusion[meridian][2] }
            result << { time: '12:12 - 12:35 ', hour: 11, point: points_infusion[meridian][3] }
            result << { time: '12:36 - 12:59 ', hour: 11, point: points_infusion[meridian][4] }
          elsif guard == 8
            meridian = '6th GUARD JI SPLEEN'
            result << { time: '13:00 - 13:23 ', hour: 13, point: points_infusion[meridian][0] }
            result << { time: '13:24 - 13:47 ', hour: 13, point: points_infusion[meridian][1] }
            result << { time: '13:48 - 14:11 ', hour: 13, point: points_infusion[meridian][2] }
            result << { time: '14:12 - 14:36 ', hour: 13, point: points_infusion[meridian][3] }
            result << { time: '14:37 - 14:59 ', hour: 13, point: points_infusion[meridian][4] }
          elsif guard == 9
            meridian = '7th GUARD GENG LARGE INT'
            result << { time: '15:00 - 15:23 ', hour: 15, point: points_infusion[meridian][0] }
            result << { time: '15:24 - 15:47 ', hour: 15, point: points_infusion[meridian][1] }
            result << { time: '15:48 - 16:11 ', hour: 15, point: points_infusion[meridian][2] }
            result << { time: '16:12 - 16:35 ', hour: 15, point: points_infusion[meridian][3] }
            result << { time: '16:36 - 16:59 ', hour: 15, point: points_infusion[meridian][4] }
          elsif guard == 10
            meridian = '8th XIN LUNGS'
            result << { time: '17:00 - 17:23 ', hour: 17, point: points_infusion[meridian][0] }
            result << { time: '17:24 - 17:47 ', hour: 17, point: points_infusion[meridian][1] }
            result << { time: '17:48 - 18:11 ', hour: 17, point: points_infusion[meridian][2] }
            result << { time: '18:12 - 18:35 ', hour: 17, point: points_infusion[meridian][3] }
            result << { time: '18:36 - 18:59 ', hour: 17, point: points_infusion[meridian][4] }
          elsif guard == 11
            meridian = '9th GUARD REN BLADDER'
            result << { time: '19:00 - 19:23 ', hour: 19, point: points_infusion[meridian][0] }
            result << { time: '19:24 - 19:47 ', hour: 19, point: points_infusion[meridian][1] }
            result << { time: '19:48 - 20:11 ', hour: 19, point: points_infusion[meridian][2] }
            result << { time: '20:12 - 20:35 ', hour: 19, point: points_infusion[meridian][3] }
            result << { time: '20:36 - 20:59 ', hour: 19, point: points_infusion[meridian][4] }
          elsif guard == 12
            meridian = '10th GUARD GUI KIDNEY'
            result << { time: '21:00 - 21:23 ', hour: 21, point: points_infusion[meridian][0] }
            result << { time: '21:24 - 21:47 ', hour: 21, point: points_infusion[meridian][1] }
            result << { time: '21:48 - 22:11 ', hour: 21, point: points_infusion[meridian][2] }
            result << { time: '22:12 - 22:35 ', hour: 21, point: points_infusion[meridian][3] }
            result << { time: '22:36 - 22:59 ', hour: 21, point: points_infusion[meridian][4] }
        end
    end
    return result
  end

  # END OF 'INFUSION' METHOD (24 MINUTES)

  def time_mark(date)
    {
      '23-01' => DateTime.new(date.year, date.month, date.day, 0, 0), # 0
      '01-03' => DateTime.new(date.year, date.month, date.day, 2, 0), # 1
      '03-05' => DateTime.new(date.year, date.month, date.day, 4, 0), # 2
      '05-07' => DateTime.new(date.year, date.month, date.day, 6, 0), # 3
      '07-09' => DateTime.new(date.year, date.month, date.day, 8, 0), # 4
      '09-11' => DateTime.new(date.year, date.month, date.day, 10, 0), # 5
      '11-13' => DateTime.new(date.year, date.month, date.day, 12, 0), # 6
      '13-15' => DateTime.new(date.year, date.month, date.day, 14, 0), # 7
      '15-17' => DateTime.new(date.year, date.month, date.day, 16, 0), # 8
      '17-19' => DateTime.new(date.year, date.month, date.day, 18, 0), # 9
      '19-21' => DateTime.new(date.year, date.month, date.day, 20, 0), # 10
      '21-23' => DateTime.new(date.year, date.month, date.day, 22, 10) # 11
    }
  end

  def points_naganfa
    points_naganfa = [

      [], # for exept zero

      [
        'TRUNC_1, GALL BLADDER',
        ' is open  Vb.44 Zu-qiao-yin',
        ' is open Ig.2 Qian-gu',
        ' are open E.43 Xian-gu' + ' and ' + 'Vb.40 Qiu-xu',
        ' is open Gi.5 Yang-xi',
        ' is open V.40 Wei-zhong',
        ' is open TR.2 Ye-men'
      ],

      [
        'TRUNC_2, LIVER',
        ' is open F.1 Da-dun',
        ' is open C.8 Shao-fu',
        ' are open Rp.3 Tai-bai and F.3 Tai-chong',
        ' is open P.8 Jing-qu',
        ' is open R.10 Yin-gu',
        ' is open MC.8 Lao-gong'
      ],

      [
        'TRUNC_3, SMALL INTESTINE',
        ' is open Ig.1 Shao-ze',
        ' is open E.44 Nei-ting',
        ' are open Gi.3 San-jian and Ig.4 Wan-gu',
        ' is open V.60 Kun-lun',
        ' is open Vb.34 Yang-ling-quan',
        ' is open TR.3 Zhong-zhu'
      ],

      [
        'TRUNC_4, HEART',
        ' is open C.9 Shao-chong',
        ' is open Rp.2 Da-du',
        ' are open P.9 Tai-yuan and C.7 Shen-men',
        ' is open R.7 Fu-liu',
        ' is open F.8 Qu-quan',
        ' is open MC.7 Da-ling'
      ],

      [
        'TRUNC_5, STOMACH',
        ' is open E.45 Li-dui',
        ' is open Gi.2 Er-jian',
        ' are open V.65 Shu-gu and E.42 Chong-yang',
        ' is open Vb.38 Yang-fu',
        ' is open Ig.8 Xiao-hai',
        ' is open TR.6 Zhi-gou'
      ],

      [
        'TRUNC_6, SPLEEN',
        ' is open Rp.1 Yin-bai',
        ' is open P.10 Yu-zi',
        ' are open R.3 Tai-xi and Rp.3 Tai-bai',
        ' is open F.4 Zhong-feng',
        ' is open C.3 Shao-xai',
        ' is open MC.5 Jian-shi'
      ],

      [
        'TRUNC_7',
        ' is open Gi.1 Shang-yang',
        ' is open V.66 Zu-tong-gu',
        ' are open Vb.41 Zu-lin-qi and Gi.4 He-gu',
        ' is open  Ig.5 Yang-gu',
        ' is open  E.36 Zu-san-li',
        ' is open  TR.10 Tian-jing'
      ],

      [
        'TRUNC_8',
        ' is open P.11 Shao-shang',
        ' is open R.2 Jan-gu',
        ' are open F.3 Tai-chong and P.9 Tai-yuan',
        ' is open C.4 Ling-dao',
        ' is open Rp.9 Yin-ling-quan',
        ' is open MC.3 Qu-ze'
      ],

      [
        'TRUNC_9, BLADDER',
        ' is open V.67 Zhi-yin',
        ' is open Vb.43 Xia-xi',
        ' are open Ig.3 Hou-xi and V.64 Jing-gu',
        ' is open E.41 Jie-xi',
        ' is open Gi.11 Qu-chi',
        ' is open TR.1 Guan-chong'
      ],

      [
        'TRUNC_10, KIDNEY',
        ' is open R.1 Yong-quan',
        ' is open F.2 Xing-jian',
        ' are open C.7 Shen-men and R.3 Tai-xi',
        ' is open Rp.5 Shang-qiu',
        ' is open P.5 Chi-ze',
        ' is open MC.9 Zhong-chong'
      ]

   ]
  end

  def opened_points_naganfa(trunc, mark, points, date)
    result = []
    case trunc
    when 1
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[10][2].to_s + ' from previous 10th trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[10][3].to_s + ' from previous 10th trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[10][4].to_s + ' from previous 10th trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[10][5].to_s + ' from previous 10th trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[10][6].to_s + ' from previous 10th trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[1][1].to_s
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[1][2].to_s
    when 2
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[1][2].to_s + ' from previous 1st trunc! - ' + date.yesterday.to_s(:short)
       # doubled point from previous day
      result <<  'from ' + ((mark['03-05'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['03-05'] + 1.hour).hour).to_s +
      ':00' + points[1][3].to_s + ' from previous 1st trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['07-09'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['07-09'] + 1.hour).hour).to_s +
      ':00' + points[1][4].to_s + ' from previous 1st trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['11-13'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['11-13'] + 1.hour).hour).to_s +
      ':00' + points[1][5].to_s + ' from previous 1st trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['15-17'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['15-17'] + 1.hour).hour).to_s +
      ':00' + points[1][6].to_s  + ' from previous 1st trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[2][1].to_s
      result <<  'from ' + ((mark['21-23'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['21-23'] + 1.hour).hour).to_s +
      ':00' + points[2][2].to_s
    when 3
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[2][3].to_s + ' from previous 2nd trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[2][4].to_s + ' from previous 2nd trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[2][5].to_s + ' from previous 2nd trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[2][6].to_s  + ' from previous 2nd trunc! - ' + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['15-17'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['15-17'] + 1.hour).hour).to_s +
      ':00' + points[3][1].to_s
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[3][2].to_s
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[3][3].to_s
    when 4
      result <<  'TRUNC DAY IS: ' + trunc.to_s
       result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[3][3].to_s + ' from previous 3rd trunc! - ' + date.yesterday.to_s(:short)
      # doubled from previous day

      result <<  'from ' + ((mark['03-05'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['03-05'] + 1.hour).hour).to_s +
      ':00' + points[3][4].to_s + ' from previous 3rd trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['07-09'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['07-09'] + 1.hour).hour).to_s +
      ':00' + points[3][5].to_s + ' from previous 3rd trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['11-13'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['11-13'] + 1.hour).hour).to_s +
      ':00' + points[3][6].to_s  + ' from previous 3rd trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[4][1].to_s
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[4][2].to_s
      result <<  'from ' + ((mark['21-23'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['21-23'] + 1.hour).hour).to_s +
      ':00' + points[4][3].to_s
    when 5
      result <<  'TRUNC DAY IS: ' + trunc.to_s
         result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[4][4].to_s + ' from previous 4th trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[4][5].to_s + ' from previous 4th trunc! - '  + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[4][6].to_s + ' from previous 4th trunc! - '  + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['11-13'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['11-13'] + 1.hour).hour).to_s +
      ':00' + points[5][1].to_s
      result <<  'from ' + ((mark['15-17'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['15-17'] + 1.hour).hour).to_s +
      ':00' + points[5][2].to_s
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[5][3].to_s
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[5][4].to_s
    when 6
      result <<  'TRUNC DAY IS: ' + trunc.to_s
          result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[5][4].to_s + ' from previous 5th trunc! - '  + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['03-05'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['03-05'] + 1.hour).hour).to_s +
      ':00' + points[5][5].to_s + ' from previous 5th trunc! - '  + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['07-09'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['07-09'] + 1.hour).hour).to_s +
      ':00' + points[5][6].to_s + ' from previous 5th trunc! - '  + date.yesterday.to_s(:short)
      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[6][1].to_s
      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[6][2].to_s
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[6][3].to_s
      result <<  'from ' + ((mark['21-23'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['21-23'] + 1.hour).hour).to_s +
      ':00' + points[6][4].to_s
    when 7
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[6][5].to_s + ' from previous 6th trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[6][6].to_s + ' from previous 6th trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['07-09'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['07-09'] + 1.hour).hour).to_s +
      ':00' + points[7][1].to_s
      result <<  'from ' + ((mark['11-13'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['11-13'] + 1.hour).hour).to_s +
      ':00' + points[7][2].to_s
      result <<  'from ' + ((mark['15-17'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['15-17'] + 1.hour).hour).to_s +
      ':00' + points[7][3].to_s
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[7][4].to_s
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[7][5].to_s
    when 8
      result <<  'TRUNC DAY IS: ' + trunc.to_s
          result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[7][5].to_s + ' from previous 7th trunc! - ' + date.yesterday.to_s(:short)
       # doubled from previous day
      result <<  'from ' + ((mark['03-05'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['03-05'] + 1.hour).hour).to_s +
      ':00' + points[7][6].to_s + ' from previous 7th trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[8][1].to_s
      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[8][2].to_s
      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[8][3].to_s
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[8][4].to_s
      result <<  'from ' + ((mark['21-23'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['21-23'] + 1.hour).hour).to_s +
      ':00' + points[8][5].to_s
    when 9
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[8][6].to_s + ' from previous 8th trunc! - ' + date.yesterday.to_s(:short)

      result <<  'from ' + ((mark['03-05'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['03-05'] + 1.hour).hour).to_s +
      ':00' + points[9][1].to_s
      result <<  'from ' + ((mark['07-09'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['07-09'] + 1.hour).hour).to_s +
      ':00' + points[9][2].to_s
      result <<  'from ' + ((mark['11-13'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['11-13'] + 1.hour).hour).to_s +
      ':00' + points[9][3].to_s
      result <<  'from ' + ((mark['15-17'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['15-17'] + 1.hour).hour).to_s +
      ':00' + points[9][4].to_s
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[9][5].to_s
      result <<  'from ' + ((mark['21-23'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['21-23'] + 1.hour).hour).to_s +
      ':00' + points[10][1].to_s + ' from next 10th trunc!'
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[9][6].to_s
    when 10
      result <<  'TRUNC DAY IS: ' + trunc.to_s
      result <<  'from ' + ((mark['01-03'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['01-03'] + 1.hour).hour).to_s +
      ':00' + points[10][2].to_s
      result <<  'from ' + ((mark['05-07'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['05-07'] + 1.hour).hour).to_s +
      ':00' + points[10][3].to_s
      result <<  'from ' + ((mark['09-11'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['09-11'] + 1.hour).hour).to_s +
      ':00' + points[10][4].to_s
      result <<  'from ' + ((mark['13-15'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['13-15'] + 1.hour).hour).to_s +
      ':00' + points[10][5].to_s
      result <<  'from ' + ((mark['17-19'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['17-19'] + 1.hour).hour).to_s +
      ':00' + points[10][6].to_s
      result <<  'from ' + ((mark['19-21'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['19-21'] + 1.hour).hour).to_s +
      ':00' + points[1][1].to_s + ' from next 1st trunc '
      result <<  'from ' + ((mark['23-01'] - 1.hour).hour).to_s + ':00' + ' to ' + ((mark['23-01'] + 1.hour).hour).to_s +
      ':00' + points[1][2].to_s + ' from next 1st trunc '
    end
    return result
  end


  # метод Сложного Баланса

  def eot_patient(birth_time)
    pi = (Math::PI) # pi
    delta = birth_time.getutc.yday - 1 # (Текущий день года - 1)

    yy = birth_time.getutc.year
    np = case yy #The number np is the number of days from 1 January to the date of the Earth's perihelion. (http://www.astropixels.com/ephemeris/perap2001.html)
          when 1921, 1929, 1937, 1945, 1970, 1978, 1989, 1997 ; 0
          when 1923, 1924, 1926, 1932, 1934, 1935, 1940, 1942, 1943, 1946, 1948, 1951, 1953, 1954,
               1956, 1959, 1961, 1962, 1964, 1965, 1967, 1973, 1975, 1981, 1983, 1986, 1994, 2002,
               2005, 2008, 2013, 2016, 2021, 2029, 2043  ; 1
          when 1920, 1922, 1925, 1927, 1930, 1931, 1933, 1938, 1939, 1941, 1949, 1950, 1957, 1958,
               1966, 1969, 1972, 1977, 1980, 1984, 1985, 1988, 1991, 1992, 1999, 2000, 2007, 2010,
               2011, 2018, 2019, 2024, 2026, 2027, 2030, 2032, 2035, 2037, 2038, 2040, 2041, 2045,
               2046, 2048, 2049  ; 2
          when 1928, 1936, 1944, 1947, 1952, 1955, 1960, 1963, 1968, 1971, 1974, 1976, 1979, 1982,
               1987, 1990, 1993, 1995, 1996, 1998, 2001, 2003, 2004, 2006, 2009, 2014, 2015, 2017,
               2022, 2023, 2025, 2031, 2033, 2034, 2042, 2050 ; 3
          when 2012, 2020, 2028, 2036, 2039, 2044, 2047 ; 4
         else ; 2
         end

    a = birth_time.getutc.to_a; delta = delta + a[2].to_f / 24 + a[1].to_f / 60 / 24 # Поправка на дробную часть дня

    lambda = 23.4406 * pi / 180; # Earth's inclination in radians
    omega = 2 * pi / 365.2564 # angular velocity of annual revolution (radians/day)
    alpha = omega * ((delta + 10) % 365) # angle in (mean) circular orbit, solar year starts 21. Dec
    beta = alpha + 0.03340560188317 * Math.sin(omega * ((delta - np) % 365)) # angle in elliptical orbit, from perigee  (radians)
    gamma = (alpha - Math.atan(Math.tan(beta) / Math.cos(lambda))) / pi # angular correction

    eot = (43200 * (gamma - gamma.round)) # equation of time in seconds
  end

  def year_number_60th_calculation(birth)
      y = birth.year % 60 - 3
      if y < 1
        y + 60
      elsif y > 60
        y - 60
        else y
      end
  end

  def number_of_day__60th_cycle_calculation(year_num, date) # номер дня пациента!
    if date.mon < 3
      mon = date.mon + 12
      year = date.year - 1
      else
      mon = date.mon
      year = date.year
    end
    n = ((((mon + 1)) * 30.6).truncate  + (year * 365.25).truncate + date.day - 114)%12
    number_of_day_60th = (n - 14)%60
    if number_of_day_60th == 0
      number_of_day_60th += 60
      else
      number_of_day_60th
    end
  end

  def guard_patient(sun_time)
    case sun_time
    when 19...21 then 11
    when 21...23 then 12
    when 23, 0 then 1
    when  1...3 then 2
    when  3...5 then 3
    when  5...7 then 4
    when  7...9 then 5
    when  9...11 then 6
    when 11...13 then 7
    when 13...15 then 8
    when 15...17 then 9
    when 17...19 then 10
    end
  end

  def ranges
    [
      { value: 11, dates: DateTime.new(1937, 1, 1)..DateTime.new(1937, 1, 12) }, # 1937
      { value: 12, dates: DateTime.new(1937, 1, 13)..DateTime.new(1937, 2, 10) },
      { value: 1, dates: DateTime.new(1937, 2, 11)..DateTime.new(1937, 3, 12) },
      { value: 2, dates: DateTime.new(1937, 3, 13)..DateTime.new(1937, 4, 10) },
      { value: 3, dates: DateTime.new(1937, 4, 11)..DateTime.new(1937, 5, 9) },
      { value: 4, dates: DateTime.new(1937, 5, 10)..DateTime.new(1937, 6, 8) },
      { value: 5, dates: DateTime.new(1937, 6, 9)..DateTime.new(1937, 7, 7) },
      { value: 6, dates: DateTime.new(1937, 7, 8)..DateTime.new(1937, 8, 5) },
      { value: 7, dates: DateTime.new(1937, 8, 6)..DateTime.new(1937, 9, 4) },
      { value: 8, dates: DateTime.new(1937, 9, 5)..DateTime.new(1937, 10, 3) },
      { value: 9, dates: DateTime.new(1937, 10, 4)..DateTime.new(1937, 11, 2) },
      { value: 10, dates: DateTime.new(1937, 11, 3)..DateTime.new(1937, 12, 2) },
      { value: 11, dates: DateTime.new(1937, 12, 3)..DateTime.new(1937, 12, 31) },

      { value: 11, dates: DateTime.new(1938, 1, 1)..DateTime.new(1938, 1, 1) }, # 1938
      { value: 12, dates: DateTime.new(1938, 1, 2)..DateTime.new(1938, 1, 30) },
      { value: 1, dates: DateTime.new(1938, 1, 31)..DateTime.new(1938, 3, 1) },
      { value: 2, dates: DateTime.new(1938, 3, 2)..DateTime.new(1938, 3, 31) },
      { value: 3, dates: DateTime.new(1938, 4, 1)..DateTime.new(1938, 4, 29) },
      { value: 4, dates: DateTime.new(1938, 4, 30)..DateTime.new(1938, 5, 28) },
      { value: 5, dates: DateTime.new(1938, 5, 29)..DateTime.new(1938, 6, 27) },
      { value: 6, dates: DateTime.new(1938, 6, 28)..DateTime.new(1938, 7, 26) },
      { value: 7, dates: DateTime.new(1938, 7, 27)..DateTime.new(1938, 8, 24) },
      { value: 7, dates: DateTime.new(1938, 8, 25)..DateTime.new(1938, 9, 23) },
      { value: 8, dates: DateTime.new(1938, 9, 24)..DateTime.new(1938, 10, 22) },
      { value: 9, dates: DateTime.new(1938, 10, 23)..DateTime.new(1938, 11, 21) },
      { value: 10, dates: DateTime.new(1938, 11, 22)..DateTime.new(1938, 12, 21) },
      { value: 11, dates: DateTime.new(1938, 12, 22)..DateTime.new(1938, 12, 31) },

      { value: 11, dates: DateTime.new(1939, 1, 1)..DateTime.new(1939, 1, 19) }, # 1939
      { value: 12, dates: DateTime.new(1939, 1, 20)..DateTime.new(1939, 2, 18) },
      { value: 1, dates: DateTime.new(1939, 2, 19)..DateTime.new(1939, 3, 20) },
      { value: 2, dates: DateTime.new(1939, 3, 21)..DateTime.new(1939, 4, 19) },
      { value: 3, dates: DateTime.new(1939, 4, 20)..DateTime.new(1939, 5, 18) },
      { value: 4, dates: DateTime.new(1939, 5, 19)..DateTime.new(1939, 6, 16) },
      { value: 5, dates: DateTime.new(1939, 6, 17)..DateTime.new(1939, 7, 16) },
      { value: 6, dates: DateTime.new(1939, 7, 17)..DateTime.new(1939, 8, 14) },
      { value: 7, dates: DateTime.new(1939, 8, 15)..DateTime.new(1939, 9, 12) },
      { value: 8, dates: DateTime.new(1939, 9, 13)..DateTime.new(1939, 10, 12) },
      { value: 9, dates: DateTime.new(1939, 10, 13)..DateTime.new(1939, 11, 10) },
      { value: 10, dates: DateTime.new(1939, 11, 11)..DateTime.new(1939, 12, 10) },
      { value: 11, dates: DateTime.new(1939, 12, 11)..DateTime.new(1939, 12, 31) },

      { value: 11, dates: DateTime.new(1940, 1, 1)..DateTime.new(1940, 1, 8) }, # 1940
      { value: 12, dates: DateTime.new(1940, 1, 9)..DateTime.new(1940, 2, 7) },
      { value: 1, dates: DateTime.new(1940, 2, 8)..DateTime.new(1940, 3, 8) },
      { value: 2, dates: DateTime.new(1940, 3, 9)..DateTime.new(1940, 4, 7) },
      { value: 3, dates: DateTime.new(1940, 4, 8)..DateTime.new(1940, 5, 6) },
      { value: 4, dates: DateTime.new(1940, 5, 7)..DateTime.new(1940, 6, 5) },
      { value: 5, dates: DateTime.new(1940, 6, 6)..DateTime.new(1940, 7, 4) },
      { value: 6, dates: DateTime.new(1940, 7, 5)..DateTime.new(1940, 8, 3) },
      { value: 7, dates: DateTime.new(1940, 8, 4)..DateTime.new(1940, 9, 1) },
      { value: 8, dates: DateTime.new(1940, 9, 2)..DateTime.new(1940, 9, 30) },
      { value: 9, dates: DateTime.new(1940, 10, 1)..DateTime.new(1940, 10, 30) },
      { value: 10, dates: DateTime.new(1940, 10, 31)..DateTime.new(1940, 11, 28) },
      { value: 11, dates: DateTime.new(1940, 11, 29)..DateTime.new(1940, 12, 28) },
      { value: 12, dates: DateTime.new(1940, 12, 29)..DateTime.new(1940, 12, 31) },

      { value: 12, dates: DateTime.new(1941, 1, 1)..DateTime.new(1941, 1, 26) },  # 1941
      { value: 1, dates: DateTime.new(1941, 1, 27)..DateTime.new(1941, 2, 25) },
      { value: 2, dates: DateTime.new(1941, 2, 26)..DateTime.new(1941, 3, 27) },
      { value: 3, dates: DateTime.new(1941, 3, 28)..DateTime.new(1941, 4, 25) },
      { value: 4, dates: DateTime.new(1941, 4, 26)..DateTime.new(1941, 5, 25) },
      { value: 5, dates: DateTime.new(1941, 5, 26)..DateTime.new(1941, 6, 24) },
      { value: 6, dates: DateTime.new(1941, 6, 25)..DateTime.new(1941, 7, 23) },
      { value: 6, dates: DateTime.new(1941, 7, 24)..DateTime.new(1941, 8, 22) },
      { value: 7, dates: DateTime.new(1941, 8, 23)..DateTime.new(1941, 9, 20) },
      { value: 8, dates: DateTime.new(1941, 9, 21)..DateTime.new(1941, 10, 19) },
      { value: 9, dates: DateTime.new(1941, 10, 20)..DateTime.new(1941, 11, 18) },
      { value: 10, dates: DateTime.new(1941, 11, 19)..DateTime.new(1941, 12, 17) },
      { value: 11, dates: DateTime.new(1941, 12, 18)..DateTime.new(1941, 12, 31) },

      { value: 11, dates: DateTime.new(1942, 1, 1)..DateTime.new(1942, 1, 16) }, # 1942
      { value: 12, dates: DateTime.new(1942, 1, 17)..DateTime.new(1942, 2, 14) },
      { value: 1, dates: DateTime.new(1942, 2, 15)..DateTime.new(1942, 3, 16) },
      { value: 2, dates: DateTime.new(1942, 3, 17)..DateTime.new(1942, 4, 14) },
      { value: 3, dates: DateTime.new(1942, 4, 15)..DateTime.new(1942, 5, 14) },
      { value: 4, dates: DateTime.new(1942, 5, 15)..DateTime.new(1942, 6, 13) },
      { value: 5, dates: DateTime.new(1942, 6, 14)..DateTime.new(1942, 7, 12) },
      { value: 6, dates: DateTime.new(1942, 7, 13)..DateTime.new(1942, 8, 11) },
      { value: 7, dates: DateTime.new(1942, 8, 12)..DateTime.new(1942, 9, 9) },
      { value: 8, dates: DateTime.new(1942, 9, 10)..DateTime.new(1942, 10, 9) },
      { value: 9, dates: DateTime.new(1942, 10, 10)..DateTime.new(1942, 11, 7) },
      { value: 10, dates: DateTime.new(1942, 11, 8)..DateTime.new(1942, 12, 7) },
      { value: 11, dates: DateTime.new(1942, 12, 8)..DateTime.new(1942, 12, 31) },

      { value: 11, dates: DateTime.new(1943, 1, 1)..DateTime.new(1943, 1, 5) }, # 1943
      { value: 12, dates: DateTime.new(1943, 1, 6)..DateTime.new(1943, 2, 4) },
      { value: 1, dates: DateTime.new(1943, 2, 5)..DateTime.new(1943, 3, 5) },
      { value: 2, dates: DateTime.new(1943, 3, 6)..DateTime.new(1943, 4, 4) },
      { value: 3, dates: DateTime.new(1943, 4, 5)..DateTime.new(1943, 5, 3) },
      { value: 4, dates: DateTime.new(1943, 5, 4)..DateTime.new(1943, 6, 2) },
      { value: 5, dates: DateTime.new(1943, 6, 3)..DateTime.new(1943, 7, 1) },
      { value: 6, dates: DateTime.new(1943, 7, 2)..DateTime.new(1943, 7, 31) },
      { value: 7, dates: DateTime.new(1943, 8, 1)..DateTime.new(1943, 8, 30) },
      { value: 8, dates: DateTime.new(1943, 8, 31)..DateTime.new(1943, 9, 28) },
      { value: 9, dates: DateTime.new(1943, 9, 29)..DateTime.new(1943, 10, 28) },
      { value: 10, dates: DateTime.new(1943, 10, 29)..DateTime.new(1943, 11, 26) },
      { value: 11, dates: DateTime.new(1943, 11, 27)..DateTime.new(1943, 12, 26) },
      { value: 12, dates: DateTime.new(1943, 12, 27)..DateTime.new(1943, 12, 31) },

      { value: 12, dates: DateTime.new(1944, 1, 1)..DateTime.new(1944, 1, 24) }, # 1944
      { value: 1, dates: DateTime.new(1944, 1, 25)..DateTime.new(1944, 2, 23) },
      { value: 2, dates: DateTime.new(1944, 2, 24)..DateTime.new(1944, 3, 23) },
      { value: 3, dates: DateTime.new(1944, 3, 24)..DateTime.new(1944, 4, 22) },
      { value: 4, dates: DateTime.new(1944, 4, 23)..DateTime.new(1944, 5, 21) },
      { value: 4, dates: DateTime.new(1944, 5, 22)..DateTime.new(1944, 6, 20) },
      { value: 5, dates: DateTime.new(1944, 6, 21)..DateTime.new(1944, 7, 19) },
      { value: 6, dates: DateTime.new(1944, 7, 20)..DateTime.new(1944, 8, 18) },
      { value: 7, dates: DateTime.new(1944, 8, 19)..DateTime.new(1944, 9, 16) },
      { value: 8, dates: DateTime.new(1944, 9, 17)..DateTime.new(1944, 10, 16) },
      { value: 9, dates: DateTime.new(1944, 10, 17)..DateTime.new(1944, 11, 15) },
      { value: 10, dates: DateTime.new(1944, 11, 16)..DateTime.new(1944, 12, 14) },
      { value: 11, dates: DateTime.new(1944, 12, 15)..DateTime.new(1944, 12, 31) },

      { value: 11, dates: DateTime.new(1945, 1, 1)..DateTime.new(1945, 1, 13) }, # 1945
      { value: 12, dates: DateTime.new(1945, 1, 14)..DateTime.new(1945, 2, 12) },
      { value: 1, dates: DateTime.new(1945, 2, 13)..DateTime.new(1945, 3, 13) },
      { value: 2, dates: DateTime.new(1945, 3, 14)..DateTime.new(1945, 4, 11) },
      { value: 3, dates: DateTime.new(1945, 4, 12)..DateTime.new(1945, 5, 11) },
      { value: 4, dates: DateTime.new(1945, 5, 12)..DateTime.new(1945, 6, 9) },
      { value: 5, dates: DateTime.new(1945, 6, 10)..DateTime.new(1945, 7, 8) },
      { value: 6, dates: DateTime.new(1945, 7, 9)..DateTime.new(1945, 8, 7) },
      { value: 7, dates: DateTime.new(1945, 8, 8)..DateTime.new(1945, 9, 5) },
      { value: 8, dates: DateTime.new(1945, 9, 6)..DateTime.new(1945, 10, 5) },
      { value: 9, dates: DateTime.new(1945, 10, 6)..DateTime.new(1945, 11, 4) },
      { value: 10, dates: DateTime.new(1945, 11, 5)..DateTime.new(1945, 12, 4) },
      { value: 11, dates: DateTime.new(1945, 12, 5)..DateTime.new(1945, 12, 31) },

      { value: 11, dates: DateTime.new(1946, 1, 1)..DateTime.new(1946, 1, 2) }, # 1946
      { value: 12, dates: DateTime.new(1946, 1, 3)..DateTime.new(1946, 2, 1) },
      { value: 1, dates: DateTime.new(1946, 2, 2)..DateTime.new(1946, 3, 3) },
      { value: 2, dates: DateTime.new(1946, 3, 4)..DateTime.new(1946, 4, 1) },
      { value: 3, dates: DateTime.new(1946, 4, 2)..DateTime.new(1946, 4, 30) },
      { value: 4, dates: DateTime.new(1946, 5, 1)..DateTime.new(1946, 5, 30) },
      { value: 5, dates: DateTime.new(1946, 5, 31)..DateTime.new(1946, 6, 28) },
      { value: 6, dates: DateTime.new(1946, 6, 29)..DateTime.new(1946, 7, 27) },
      { value: 7, dates: DateTime.new(1946, 7, 28)..DateTime.new(1946, 8, 26) },
      { value: 8, dates: DateTime.new(1946, 8, 27)..DateTime.new(1946, 9, 24) },
      { value: 9, dates: DateTime.new(1946, 9, 25)..DateTime.new(1946, 10, 24) },
      { value: 10, dates: DateTime.new(1946, 10, 25)..DateTime.new(1946, 11, 23) },
      { value: 11, dates: DateTime.new(1946, 11, 24)..DateTime.new(1946, 12, 22) },
      { value: 12, dates: DateTime.new(1946, 12, 23)..DateTime.new(1946, 12, 31) },

      { value: 12, dates: DateTime.new(1947, 1, 1)..DateTime.new(1947, 1, 21) }, # 1947
      { value: 1, dates: DateTime.new(1947, 1, 22)..DateTime.new(1947, 2, 20) },
      { value: 2, dates: DateTime.new(1947, 2, 21)..DateTime.new(1947, 3, 22) },
      { value: 2, dates: DateTime.new(1947, 3, 23)..DateTime.new(1947, 4, 20) },
      { value: 3, dates: DateTime.new(1947, 4, 21)..DateTime.new(1947, 5, 19) },
      { value: 4, dates: DateTime.new(1947, 5, 20)..DateTime.new(1947, 6, 18) },
      { value: 5, dates: DateTime.new(1947, 6, 19)..DateTime.new(1947, 7, 17) },
      { value: 6, dates: DateTime.new(1947, 7, 18)..DateTime.new(1947, 8, 15) },
      { value: 7, dates: DateTime.new(1947, 8, 16)..DateTime.new(1947, 9, 14) },
      { value: 8, dates: DateTime.new(1947, 9, 15)..DateTime.new(1947, 10, 13) },
      { value: 9, dates: DateTime.new(1947, 10, 14)..DateTime.new(1947, 11, 12) },
      { value: 10, dates: DateTime.new(1947, 11, 13)..DateTime.new(1947, 12, 11) },
      { value: 11, dates: DateTime.new(1947, 12, 12)..DateTime.new(1947, 12, 31) },

      { value: 11, dates: DateTime.new(1948, 1, 1)..DateTime.new(1948, 1, 10) },  # 1948
      { value: 12, dates: DateTime.new(1948, 1, 11)..DateTime.new(1948, 2, 9) },
      { value: 1, dates: DateTime.new(1948, 2, 10)..DateTime.new(1948, 3, 10) },
      { value: 2, dates: DateTime.new(1948, 3, 11)..DateTime.new(1948, 4, 8) },
      { value: 3, dates: DateTime.new(1948, 4, 9)..DateTime.new(1948, 5, 8) },
      { value: 4, dates: DateTime.new(1948, 5, 9)..DateTime.new(1948, 6, 6) },
      { value: 5, dates: DateTime.new(1948, 6, 7)..DateTime.new(1948, 7, 6) },
      { value: 6, dates: DateTime.new(1948, 7, 7)..DateTime.new(1948, 8, 4) },
      { value: 7, dates: DateTime.new(1948, 8, 5)..DateTime.new(1948, 9, 2) },
      { value: 8, dates: DateTime.new(1948, 9, 3)..DateTime.new(1948, 10, 2) },
      { value: 9, dates: DateTime.new(1948, 10, 3)..DateTime.new(1948, 10, 31) },
      { value: 10, dates: DateTime.new(1948, 11, 1)..DateTime.new(1948, 11, 30) },
      { value: 11, dates: DateTime.new(1948, 12, 1)..DateTime.new(1948, 12, 29) },
      { value: 12, dates: DateTime.new(1948, 12, 30)..DateTime.new(1948, 12, 31) },

      { value: 12, dates: DateTime.new(1949, 1, 1)..DateTime.new(1949, 1, 28) }, # 1949
      { value: 1, dates: DateTime.new(1949, 1, 29)..DateTime.new(1949, 2, 27) },
      { value: 2, dates: DateTime.new(1949, 2, 28)..DateTime.new(1949, 3, 28) },
      { value: 3, dates: DateTime.new(1949, 3, 29)..DateTime.new(1949, 4, 27) },
      { value: 4, dates: DateTime.new(1949, 4, 28)..DateTime.new(1949, 5, 27) },
      { value: 5, dates: DateTime.new(1949, 5, 28)..DateTime.new(1949, 6, 25) },
      { value: 6, dates: DateTime.new(1949, 6, 26)..DateTime.new(1949, 7, 25) },
      { value: 7, dates: DateTime.new(1949, 7, 26)..DateTime.new(1949, 8, 23) },
      { value: 7, dates: DateTime.new(1949, 8, 24)..DateTime.new(1949, 9, 21) },
      { value: 8, dates: DateTime.new(1949, 9, 22)..DateTime.new(1949, 10, 21) },
      { value: 9, dates: DateTime.new(1949, 10, 22)..DateTime.new(1949, 11, 19) },
      { value: 10, dates: DateTime.new(1949, 11, 20)..DateTime.new(1949, 12, 19) },
      { value: 11, dates: DateTime.new(1949, 12, 20)..DateTime.new(1949, 12, 31) },

      { value: 11, dates: DateTime.new(1950, 1, 1)..DateTime.new(1950, 1, 17) }, # 1950
      { value: 12, dates: DateTime.new(1950, 1, 18)..DateTime.new(1950, 2, 16) },
      { value: 1, dates: DateTime.new(1950, 2, 17)..DateTime.new(1950, 3, 17) },
      { value: 2, dates: DateTime.new(1950, 3, 18)..DateTime.new(1950, 4, 16) },
      { value: 3, dates: DateTime.new(1950, 4, 17)..DateTime.new(1950, 5, 16) },
      { value: 4, dates: DateTime.new(1950, 5, 17)..DateTime.new(1950, 6, 14) },
      { value: 5, dates: DateTime.new(1950, 6, 15)..DateTime.new(1950, 7, 14) },
      { value: 6, dates: DateTime.new(1950, 7, 15)..DateTime.new(1950, 8, 13) },
      { value: 7, dates: DateTime.new(1950, 8, 14)..DateTime.new(1950, 9, 11) },
      { value: 8, dates: DateTime.new(1950, 9, 12)..DateTime.new(1950, 10, 10) },
      { value: 9, dates: DateTime.new(1950, 10, 11)..DateTime.new(1950, 11, 9) },
      { value: 10, dates: DateTime.new(1950, 11, 10)..DateTime.new(1950, 12, 8) },
      { value: 11, dates: DateTime.new(1950, 12, 9)..DateTime.new(1950, 12, 31) },

      { value: 11, dates: DateTime.new(1951, 1, 1)..DateTime.new(1951, 1, 7) }, # 1951
      { value: 12, dates: DateTime.new(1951, 1, 8)..DateTime.new(1951, 2, 5) },
      { value: 1, dates: DateTime.new(1951, 2, 6)..DateTime.new(1951, 3, 7) },
      { value: 2, dates: DateTime.new(1951, 3, 8)..DateTime.new(1951, 4, 5) },
      { value: 3, dates: DateTime.new(1951, 4, 6)..DateTime.new(1951, 5, 5) },
      { value: 4, dates: DateTime.new(1951, 5, 6)..DateTime.new(1951, 6, 4) },
      { value: 5, dates: DateTime.new(1951, 6, 5)..DateTime.new(1951, 7, 3) },
      { value: 6, dates: DateTime.new(1951, 7, 4)..DateTime.new(1951, 8, 2) },
      { value: 7, dates: DateTime.new(1951, 8, 3)..DateTime.new(1951, 8, 31) },
      { value: 8, dates: DateTime.new(1951, 9, 1)..DateTime.new(1951, 9, 30) },
      { value: 9, dates: DateTime.new(1951, 10, 1)..DateTime.new(1951, 10, 29) },
      { value: 10, dates: DateTime.new(1951, 10, 30)..DateTime.new(1951, 11, 28) },
      { value: 11, dates: DateTime.new(1951, 11, 29)..DateTime.new(1951, 12, 27) },
      { value: 12, dates: DateTime.new(1951, 12, 28)..DateTime.new(1951, 12, 31) },

      { value: 12, dates: DateTime.new(1952, 1, 1)..DateTime.new(1952, 1, 26) }, # 1952
      { value: 1, dates: DateTime.new(1952, 1, 27)..DateTime.new(1952, 2, 24) },
      { value: 2, dates: DateTime.new(1952, 2, 25)..DateTime.new(1952, 3, 25) },
      { value: 3, dates: DateTime.new(1952, 3, 26)..DateTime.new(1952, 4, 23) },
      { value: 4, dates: DateTime.new(1952, 4, 24)..DateTime.new(1952, 5, 23) },
      { value: 5, dates: DateTime.new(1952, 5, 24)..DateTime.new(1952, 6, 21) },
      { value: 5, dates: DateTime.new(1952, 6, 22)..DateTime.new(1952, 7, 21) },
      { value: 6, dates: DateTime.new(1952, 7, 22)..DateTime.new(1952, 8, 19) },
      { value: 7, dates: DateTime.new(1952, 8, 20)..DateTime.new(1952, 9, 18) },
      { value: 8, dates: DateTime.new(1952, 9, 19)..DateTime.new(1952, 10, 18) },
      { value: 9, dates: DateTime.new(1952, 10, 19)..DateTime.new(1952, 11, 16) },
      { value: 10, dates: DateTime.new(1952, 11, 17)..DateTime.new(1952, 12, 16) },
      { value: 11, dates: DateTime.new(1952, 12, 17)..DateTime.new(1952, 12, 31) },

      { value: 11, dates: DateTime.new(1953, 1, 1)..DateTime.new(1953, 1, 14) }, # 1953
      { value: 12, dates: DateTime.new(1953, 1, 15)..DateTime.new(1953, 2, 13) },
      { value: 1, dates: DateTime.new(1953, 2, 14)..DateTime.new(1953, 3, 14) },
      { value: 2, dates: DateTime.new(1953, 3, 15)..DateTime.new(1953, 4, 13) },
      { value: 3, dates: DateTime.new(1953, 4, 14)..DateTime.new(1953, 5, 12) },
      { value: 4, dates: DateTime.new(1953, 5, 13)..DateTime.new(1953, 6, 10) },
      { value: 5, dates: DateTime.new(1953, 6, 11)..DateTime.new(1953, 7, 10) },
      { value: 6, dates: DateTime.new(1953, 7, 11)..DateTime.new(1953, 8, 9) },
      { value: 7, dates: DateTime.new(1953, 8, 10)..DateTime.new(1953, 9, 7) },
      { value: 8, dates: DateTime.new(1953, 9, 8)..DateTime.new(1953, 10, 7) },
      { value: 9, dates: DateTime.new(1953, 10, 8)..DateTime.new(1953, 11, 6) },
      { value: 10, dates: DateTime.new(1953, 11, 7)..DateTime.new(1953, 12, 5) },
      { value: 11, dates: DateTime.new(1953, 12, 6)..DateTime.new(1953, 12, 31) },

      { value: 11, dates: DateTime.new(1954, 1, 1)..DateTime.new(1954, 1, 4) }, # 1954
      { value: 12, dates: DateTime.new(1954, 1, 5)..DateTime.new(1954, 2, 2) },
      { value: 1, dates: DateTime.new(1954, 2, 3)..DateTime.new(1954, 3, 4) },
      { value: 2, dates: DateTime.new(1954, 3, 5)..DateTime.new(1954, 4, 2) },
      { value: 3, dates: DateTime.new(1954, 4, 3)..DateTime.new(1954, 5, 2) },
      { value: 4, dates: DateTime.new(1954, 5, 3)..DateTime.new(1954, 5, 31) },
      { value: 5, dates: DateTime.new(1954, 6, 1)..DateTime.new(1954, 6, 29) },
      { value: 6, dates: DateTime.new(1954, 6, 30)..DateTime.new(1954, 7, 29) },
      { value: 7, dates: DateTime.new(1954, 7, 30)..DateTime.new(1954, 8, 27) },
      { value: 8, dates: DateTime.new(1954, 8, 28)..DateTime.new(1954, 9, 26) },
      { value: 9, dates: DateTime.new(1954, 9, 27)..DateTime.new(1954, 10, 26) },
      { value: 10, dates: DateTime.new(1954, 10, 27)..DateTime.new(1954, 11, 24) },
      { value: 11, dates: DateTime.new(1954, 11, 25)..DateTime.new(1954, 12, 24) },
      { value: 12, dates: DateTime.new(1954, 12, 25)..DateTime.new(1954, 12, 31) },

      { value: 12, dates: DateTime.new(1955, 1, 1)..DateTime.new(1955, 1, 23) }, # 1955
      { value: 1, dates: DateTime.new(1955, 1, 24)..DateTime.new(1955, 2, 21) },
      { value: 2, dates: DateTime.new(1955, 2, 22)..DateTime.new(1955, 3, 23) },
      { value: 3, dates: DateTime.new(1955, 3, 24)..DateTime.new(1955, 4, 21) },
      { value: 3, dates: DateTime.new(1955, 4, 22)..DateTime.new(1955, 5, 21) },
      { value: 4, dates: DateTime.new(1955, 5, 22)..DateTime.new(1955, 6, 19) },
      { value: 5, dates: DateTime.new(1955, 6, 20)..DateTime.new(1955, 7, 18) },
      { value: 6, dates: DateTime.new(1955, 7, 19)..DateTime.new(1955, 8, 17) },
      { value: 7, dates: DateTime.new(1955, 8, 18)..DateTime.new(1955, 9, 15) },
      { value: 8, dates: DateTime.new(1955, 9, 16)..DateTime.new(1955, 10, 15) },
      { value: 9, dates: DateTime.new(1955, 10, 16)..DateTime.new(1955, 11, 13) },
      { value: 10, dates: DateTime.new(1955, 11, 14)..DateTime.new(1955, 12, 13) },
      { value: 11, dates: DateTime.new(1955, 12, 14)..DateTime.new(1955, 12, 31) },

      { value: 11, dates: DateTime.new(1956, 1, 1)..DateTime.new(1956, 1, 12) }, # 1956
      { value: 12, dates: DateTime.new(1956, 1, 13)..DateTime.new(1956, 2, 11) },
      { value: 1, dates: DateTime.new(1956, 2, 12)..DateTime.new(1956, 3, 11) },
      { value: 2, dates: DateTime.new(1956, 3, 12)..DateTime.new(1956, 4, 10) },
      { value: 3, dates: DateTime.new(1956, 4, 11)..DateTime.new(1956, 5, 9) },
      { value: 4, dates: DateTime.new(1956, 5, 10)..DateTime.new(1956, 6, 8) },
      { value: 5, dates: DateTime.new(1956, 6, 9)..DateTime.new(1956, 7, 7) },
      { value: 6, dates: DateTime.new(1956, 7, 8)..DateTime.new(1956, 8, 5) },
      { value: 7, dates: DateTime.new(1956, 8, 6)..DateTime.new(1956, 9, 4) },
      { value: 8, dates: DateTime.new(1956, 9, 5)..DateTime.new(1956, 10, 3) },
      { value: 9, dates: DateTime.new(1956, 10, 4)..DateTime.new(1956, 11, 2) },
      { value: 10, dates: DateTime.new(1956, 11, 3)..DateTime.new(1956, 12, 1) },
      { value: 11, dates: DateTime.new(1956, 12, 2)..DateTime.new(1956, 12, 31) },

      { value: 12, dates: DateTime.new(1957, 1, 1)..DateTime.new(1957, 1, 30) }, # 1957
      { value: 1, dates: DateTime.new(1957, 1, 31)..DateTime.new(1957, 3, 1) },
      { value: 2, dates: DateTime.new(1957, 3, 2)..DateTime.new(1957, 3, 30) },
      { value: 3, dates: DateTime.new(1957, 3, 31)..DateTime.new(1957, 4, 29) },
      { value: 4, dates: DateTime.new(1957, 4, 30)..DateTime.new(1957, 5, 28) },
      { value: 5, dates: DateTime.new(1957, 5, 29)..DateTime.new(1957, 6, 27) },
      { value: 6, dates: DateTime.new(1957, 6, 28)..DateTime.new(1957, 7, 26) },
      { value: 7, dates: DateTime.new(1957, 7, 27)..DateTime.new(1957, 8, 24) },
      { value: 8, dates: DateTime.new(1957, 8, 25)..DateTime.new(1957, 9, 23) },
      { value: 8, dates: DateTime.new(1957, 9, 24)..DateTime.new(1957, 10, 22) },
      { value: 9, dates: DateTime.new(1957, 10, 23)..DateTime.new(1957, 11, 21) },
      { value: 10, dates: DateTime.new(1957, 11, 22)..DateTime.new(1957, 12, 20) },
      { value: 11, dates: DateTime.new(1957, 12, 21)..DateTime.new(1957, 12, 31) },

      { value: 11, dates: DateTime.new(1958, 1, 1)..DateTime.new(1958, 1, 19) }, # 1958
      { value: 12, dates: DateTime.new(1958, 1, 20)..DateTime.new(1958, 2, 17) },
      { value: 1, dates: DateTime.new(1958, 2, 18)..DateTime.new(1958, 3, 19) },
      { value: 2, dates: DateTime.new(1958, 3, 20)..DateTime.new(1958, 4, 18) },
      { value: 3, dates: DateTime.new(1958, 4, 19)..DateTime.new(1958, 5, 18) },
      { value: 4, dates: DateTime.new(1958, 5, 19)..DateTime.new(1958, 6, 16) },
      { value: 5, dates: DateTime.new(1958, 6, 17)..DateTime.new(1958, 7, 16) },
      { value: 6, dates: DateTime.new(1958, 7, 17)..DateTime.new(1958, 8, 14) },
      { value: 7, dates: DateTime.new(1958, 8, 15)..DateTime.new(1958, 9, 12) },
      { value: 8, dates: DateTime.new(1958, 9, 13)..DateTime.new(1958, 10, 12) },
      { value: 9, dates: DateTime.new(1958, 10, 13)..DateTime.new(1958, 11, 10) },
      { value: 10, dates: DateTime.new(1958, 11, 11)..DateTime.new(1958, 12, 10) },
      { value: 11, dates: DateTime.new(1958, 12, 11)..DateTime.new(1958, 12, 31) },

      { value: 11, dates: DateTime.new(1959, 1, 1)..DateTime.new(1959, 1, 8) }, # 1959
      { value: 12, dates: DateTime.new(1959, 1, 9)..DateTime.new(1959, 2, 7) },
      { value: 1, dates: DateTime.new(1959, 2, 8)..DateTime.new(1959, 3, 8) },
      { value: 2, dates: DateTime.new(1959, 3, 9)..DateTime.new(1959, 4, 7) },
      { value: 3, dates: DateTime.new(1959, 4, 8)..DateTime.new(1959, 5, 7) },
      { value: 4, dates: DateTime.new(1959, 5, 8)..DateTime.new(1959, 6, 5) },
      { value: 5, dates: DateTime.new(1959, 6, 6)..DateTime.new(1959, 7, 5) },
      { value: 6, dates: DateTime.new(1959, 7, 6)..DateTime.new(1959, 8, 3) },
      { value: 7, dates: DateTime.new(1959, 8, 4)..DateTime.new(1959, 9, 2) },
      { value: 8, dates: DateTime.new(1959, 9, 3)..DateTime.new(1959, 10, 1) },
      { value: 9, dates: DateTime.new(1959, 10, 2)..DateTime.new(1959, 10, 31) },
      { value: 10, dates: DateTime.new(1959, 11, 1)..DateTime.new(1959, 11, 29) },
      { value: 11, dates: DateTime.new(1959, 11, 30)..DateTime.new(1959, 12, 29) },
      { value: 12, dates: DateTime.new(1959, 12, 30)..DateTime.new(1959, 12, 31) },

      { value: 12, dates: DateTime.new(1960, 1, 1)..DateTime.new(1960, 1, 27) }, # 1960
      { value: 1, dates: DateTime.new(1960, 1, 28)..DateTime.new(1960, 2, 26) },
      { value: 2, dates: DateTime.new(1960, 2, 27)..DateTime.new(1960, 3, 26) },
      { value: 3, dates: DateTime.new(1960, 3, 27)..DateTime.new(1960, 4, 25) },
      { value: 4, dates: DateTime.new(1960, 4, 26)..DateTime.new(1960, 5, 24) },
      { value: 5, dates: DateTime.new(1960, 5, 25)..DateTime.new(1960, 6, 23) },
      { value: 6, dates: DateTime.new(1960, 6, 24)..DateTime.new(1960, 7, 23) },
      { value: 6, dates: DateTime.new(1960, 7, 24)..DateTime.new(1960, 8, 21) },
      { value: 7, dates: DateTime.new(1960, 8, 22)..DateTime.new(1960, 9, 20) },
      { value: 8, dates: DateTime.new(1960, 9, 21)..DateTime.new(1960, 10, 19) },
      { value: 9, dates: DateTime.new(1960, 10, 20)..DateTime.new(1960, 11, 18) },
      { value: 10, dates: DateTime.new(1960, 11, 19)..DateTime.new(1960, 12, 17) },
      { value: 11, dates: DateTime.new(1960, 12, 18)..DateTime.new(1960, 12, 31) },

      { value: 11, dates: DateTime.new(1961, 1, 1)..DateTime.new(1961, 1, 16) }, # 1961
      { value: 12, dates: DateTime.new(1961, 1, 17)..DateTime.new(1961, 2, 14) },
      { value: 1, dates: DateTime.new(1961, 2, 15)..DateTime.new(1961, 3, 16) },
      { value: 2, dates: DateTime.new(1961, 3, 17)..DateTime.new(1961, 4, 14) },
      { value: 3, dates: DateTime.new(1961, 4, 15)..DateTime.new(1961, 5, 14) },
      { value: 4, dates: DateTime.new(1961, 5, 15)..DateTime.new(1961, 6, 12) },
      { value: 5, dates: DateTime.new(1961, 6, 13)..DateTime.new(1961, 7, 12) },
      { value: 6, dates: DateTime.new(1961, 7, 13)..DateTime.new(1961, 8, 10) },
      { value: 7, dates: DateTime.new(1961, 8, 11)..DateTime.new(1961, 9, 9) },
      { value: 8, dates: DateTime.new(1961, 9, 10)..DateTime.new(1961, 10, 9) },
      { value: 9, dates: DateTime.new(1961, 10, 10)..DateTime.new(1961, 11, 7) },
      { value: 10, dates: DateTime.new(1961, 11, 8)..DateTime.new(1961, 12, 7) },
      { value: 11, dates: DateTime.new(1961, 12, 8)..DateTime.new(1961, 12, 31) },

      { value: 11, dates: DateTime.new(1962, 1, 1)..DateTime.new(1962, 1, 5) }, # 1962
      { value: 12, dates: DateTime.new(1962, 1, 6)..DateTime.new(1962, 2, 4) },
      { value: 1, dates: DateTime.new(1962, 2, 5)..DateTime.new(1962, 3, 5) },
      { value: 2, dates: DateTime.new(1962, 3, 6)..DateTime.new(1962, 4, 4) },
      { value: 3, dates: DateTime.new(1962, 4, 5)..DateTime.new(1962, 5, 3) },
      { value: 4, dates: DateTime.new(1962, 5, 4)..DateTime.new(1962, 6, 1) },
      { value: 5, dates: DateTime.new(1962, 6, 2)..DateTime.new(1962, 7, 1) },
      { value: 6, dates: DateTime.new(1962, 7, 2)..DateTime.new(1962, 7, 30) },
      { value: 7, dates: DateTime.new(1962, 7, 31)..DateTime.new(1962, 8, 29) },
      { value: 8, dates: DateTime.new(1962, 8, 30)..DateTime.new(1962, 9, 28) },
      { value: 9, dates: DateTime.new(1962, 9, 29)..DateTime.new(1962, 10, 27) },
      { value: 10, dates: DateTime.new(1962, 10, 28)..DateTime.new(1962, 11, 26) },
      { value: 11, dates: DateTime.new(1962, 11, 27)..DateTime.new(1962, 12, 26) },
      { value: 12, dates: DateTime.new(1962, 12, 27)..DateTime.new(1962, 12, 31) },

      { value: 12, dates: DateTime.new(1963, 1, 1)..DateTime.new(1963, 1, 24) }, # 1963
      { value: 1, dates: DateTime.new(1963, 1, 25)..DateTime.new(1963, 2, 23) },
      { value: 2, dates: DateTime.new(1963, 2, 24)..DateTime.new(1963, 3, 24) },
      { value: 3, dates: DateTime.new(1963, 3, 25)..DateTime.new(1963, 4, 23) },
      { value: 4, dates: DateTime.new(1963, 4, 24)..DateTime.new(1963, 5, 22) },
      { value: 4, dates: DateTime.new(1963, 5, 23)..DateTime.new(1963, 6, 20) },
      { value: 5, dates: DateTime.new(1963, 6, 21)..DateTime.new(1963, 7, 20) },
      { value: 6, dates: DateTime.new(1963, 7, 21)..DateTime.new(1963, 8, 18) },
      { value: 7, dates: DateTime.new(1963, 8, 19)..DateTime.new(1963, 9, 17) },
      { value: 8, dates: DateTime.new(1963, 9, 18)..DateTime.new(1963, 10, 16) },
      { value: 9, dates: DateTime.new(1963, 10, 17)..DateTime.new(1963, 11, 15) },
      { value: 10, dates: DateTime.new(1963, 11, 16)..DateTime.new(1963, 12, 15) },
      { value: 11, dates: DateTime.new(1963, 12, 16)..DateTime.new(1963, 12, 31) },

      { value: 11, dates: DateTime.new(1964, 1, 1)..DateTime.new(1964, 1, 14) }, # 1964
      { value: 12, dates: DateTime.new(1964, 1, 15)..DateTime.new(1964, 2, 12) },
      { value: 1, dates: DateTime.new(1964, 2, 13)..DateTime.new(1964, 3, 13) },
      { value: 2, dates: DateTime.new(1964, 3, 14)..DateTime.new(1964, 4, 11) },
      { value: 3, dates: DateTime.new(1964, 4, 12)..DateTime.new(1964, 5, 11) },
      { value: 4, dates: DateTime.new(1964, 5, 12)..DateTime.new(1964, 6, 9) },
      { value: 5, dates: DateTime.new(1964, 6, 10)..DateTime.new(1964, 7, 8) },
      { value: 6, dates: DateTime.new(1964, 7, 9)..DateTime.new(1964, 8, 7) },
      { value: 7, dates: DateTime.new(1964, 8, 8)..DateTime.new(1964, 9, 5) },
      { value: 8, dates: DateTime.new(1964, 9, 6)..DateTime.new(1964, 10, 5) },
      { value: 9, dates: DateTime.new(1964, 10, 6)..DateTime.new(1964, 11, 3) },
      { value: 10, dates: DateTime.new(1964, 11, 4)..DateTime.new(1964, 12, 3) },
      { value: 11, dates: DateTime.new(1964, 12, 4)..DateTime.new(1964, 12, 31) },


      { value: 11, dates: DateTime.new(1965, 1, 1)..DateTime.new(1965, 1, 2) }, # 1965
      { value: 12, dates: DateTime.new(1965, 1, 3)..DateTime.new(1965, 2, 1) },
      { value: 1, dates: DateTime.new(1965, 2, 2)..DateTime.new(1965, 3, 2) },
      { value: 2, dates: DateTime.new(1965, 3, 3)..DateTime.new(1965, 4, 1) },
      { value: 3, dates: DateTime.new(1965, 4, 2)..DateTime.new(1965, 4, 30) },
      { value: 4, dates: DateTime.new(1965, 5, 1)..DateTime.new(1965, 5, 30) },
      { value: 5, dates: DateTime.new(1965, 5, 31)..DateTime.new(1965, 6, 28) },
      { value: 6, dates: DateTime.new(1965, 6, 29)..DateTime.new(1965, 7, 27) },
      { value: 7, dates: DateTime.new(1965, 7, 28)..DateTime.new(1965, 8, 26) },
      { value: 8, dates: DateTime.new(1965, 8, 27)..DateTime.new(1965, 9, 24) },
      { value: 9, dates: DateTime.new(1965, 9, 25)..DateTime.new(1965, 10, 23) },
      { value: 10, dates: DateTime.new(1965, 10, 24)..DateTime.new(1965, 11, 22) },
      { value: 11, dates: DateTime.new(1965, 11, 23)..DateTime.new(1965, 12, 22) },
      { value: 12, dates: DateTime.new(1965, 12, 23)..DateTime.new(1965, 12, 31) },

      { value: 12, dates: DateTime.new(1966, 1, 1)..DateTime.new(1966, 1, 20) }, # 1966
      { value: 1, dates: DateTime.new(1966, 1, 21)..DateTime.new(1966, 2, 19) },
      { value: 2, dates: DateTime.new(1966, 2, 20)..DateTime.new(1966, 3, 21) },
      { value: 3, dates: DateTime.new(1966, 3, 22)..DateTime.new(1966, 4, 20) },
      { value: 3, dates: DateTime.new(1966, 4, 21)..DateTime.new(1966, 5, 19) },
      { value: 4, dates: DateTime.new(1966, 5, 20)..DateTime.new(1966, 6, 18) },
      { value: 5, dates: DateTime.new(1966, 6, 19)..DateTime.new(1966, 7, 17) },
      { value: 6, dates: DateTime.new(1966, 7, 18)..DateTime.new(1966, 8, 15) },
      { value: 7, dates: DateTime.new(1966, 8, 16)..DateTime.new(1966, 9, 14) },
      { value: 8, dates: DateTime.new(1966, 9, 15)..DateTime.new(1966, 10, 13) },
      { value: 9, dates: DateTime.new(1966, 10, 14)..DateTime.new(1966, 11, 11) },
      { value: 10, dates: DateTime.new(1966, 11, 12)..DateTime.new(1966, 12, 11) },
      { value: 11, dates: DateTime.new(1966, 12, 12)..DateTime.new(1966, 12, 31) },

      { value: 11, dates: DateTime.new(1967, 1, 1)..DateTime.new(1967, 1, 10) }, # 1967
      { value: 12, dates: DateTime.new(1967, 1, 11)..DateTime.new(1967, 2, 8) },
      { value: 1, dates: DateTime.new(1967, 2, 9)..DateTime.new(1967, 3, 10) },
      { value: 2, dates: DateTime.new(1967, 3, 11)..DateTime.new(1967, 4, 9) },
      { value: 3, dates: DateTime.new(1967, 4, 10)..DateTime.new(1967, 5, 8) },
      { value: 4, dates: DateTime.new(1967, 5, 9)..DateTime.new(1967, 6, 7) },
      { value: 5, dates: DateTime.new(1967, 6, 8)..DateTime.new(1967, 7, 7) },
      { value: 6, dates: DateTime.new(1967, 7, 8)..DateTime.new(1967, 8, 5) },
      { value: 7, dates: DateTime.new(1967, 8, 6)..DateTime.new(1967, 9, 3) },
      { value: 8, dates: DateTime.new(1967, 9, 4)..DateTime.new(1967, 10, 3) },
      { value: 9, dates: DateTime.new(1967, 10, 4)..DateTime.new(1967, 11, 1) },
      { value: 10, dates: DateTime.new(1967, 11, 2)..DateTime.new(1967, 12, 1) },
      { value: 11, dates: DateTime.new(1967, 12, 2)..DateTime.new(1967, 12, 30) },
      { value: 12, dates: DateTime.new(1967, 12, 31)..DateTime.new(1967, 12, 31) },

      { value: 12, dates: DateTime.new(1968, 1, 1)..DateTime.new(1968, 1, 29) }, # 1968
      { value: 1, dates: DateTime.new(1968, 1, 30)..DateTime.new(1968, 2, 27) },
      { value: 2, dates: DateTime.new(1968, 2, 28)..DateTime.new(1968, 3, 28) },
      { value: 3, dates: DateTime.new(1968, 3, 29)..DateTime.new(1968, 4, 26) },
      { value: 4, dates: DateTime.new(1968, 4, 27)..DateTime.new(1968, 5, 26) },
      { value: 5, dates: DateTime.new(1968, 5, 27)..DateTime.new(1968, 6, 25) },
      { value: 6, dates: DateTime.new(1968, 6, 26)..DateTime.new(1968, 7, 24) },
      { value: 7, dates: DateTime.new(1968, 7, 25)..DateTime.new(1968, 8, 23) },
      { value: 7, dates: DateTime.new(1968, 8, 24)..DateTime.new(1968, 9, 21) },
      { value: 8, dates: DateTime.new(1968, 9, 22)..DateTime.new(1968, 10, 21) },
      { value: 9, dates: DateTime.new(1968, 10, 22)..DateTime.new(1968, 11, 19) },
      { value: 10, dates: DateTime.new(1968, 11, 20)..DateTime.new(1968, 12, 19) },
      { value: 11, dates: DateTime.new(1968, 12, 20)..DateTime.new(1968, 12, 31) },

      { value: 11, dates: DateTime.new(1969, 1, 1)..DateTime.new(1969, 1, 17) }, # 1969
      { value: 12, dates: DateTime.new(1969, 1, 18)..DateTime.new(1969, 2, 16) },
      { value: 1, dates: DateTime.new(1969, 2, 17)..DateTime.new(1969, 3, 17) },
      { value: 2, dates: DateTime.new(1969, 3, 18)..DateTime.new(1969, 4, 16) },
      { value: 3, dates: DateTime.new(1969, 4, 17)..DateTime.new(1969, 5, 15) },
      { value: 4, dates: DateTime.new(1969, 5, 16)..DateTime.new(1969, 6, 14) },
      { value: 5, dates: DateTime.new(1969, 6, 15)..DateTime.new(1969, 7, 13) },
      { value: 6, dates: DateTime.new(1969, 7, 14)..DateTime.new(1969, 8, 12) },
      { value: 7, dates: DateTime.new(1969, 8, 13)..DateTime.new(1969, 9, 11) },
      { value: 8, dates: DateTime.new(1969, 9, 12)..DateTime.new(1969, 10, 10) },
      { value: 9, dates: DateTime.new(1969, 10, 11)..DateTime.new(1969, 11, 9) },
      { value: 10, dates: DateTime.new(1969, 11, 10)..DateTime.new(1969, 12, 8) },
      { value: 11, dates: DateTime.new(1969, 12, 9)..DateTime.new(1969, 12, 31) },

      { value: 11, dates: DateTime.new(1970, 1, 1)..DateTime.new(1970, 1, 7) }, # 1970
      { value: 12, dates: DateTime.new(1970, 1, 8)..DateTime.new(1970, 2, 5) },
      { value: 1, dates: DateTime.new(1970, 2, 6)..DateTime.new(1970, 3, 7) },
      { value: 2, dates: DateTime.new(1970, 3, 8)..DateTime.new(1970, 4, 5) },
      { value: 3, dates: DateTime.new(1970, 4, 6)..DateTime.new(1970, 5, 4) },
      { value: 4, dates: DateTime.new(1970, 5, 5)..DateTime.new(1970, 6, 3) },
      { value: 5, dates: DateTime.new(1970, 6, 4)..DateTime.new(1970, 7, 2) },
      { value: 6, dates: DateTime.new(1970, 7, 3)..DateTime.new(1970, 8, 1) },
      { value: 7, dates: DateTime.new(1970, 8, 2)..DateTime.new(1970, 8, 31) },
      { value: 8, dates: DateTime.new(1970, 9, 1)..DateTime.new(1970, 9, 29) },
      { value: 9, dates: DateTime.new(1970, 9, 30)..DateTime.new(1970, 10, 29) },
      { value: 10, dates: DateTime.new(1970, 10, 30)..DateTime.new(1970, 11, 28) },
      { value: 11, dates: DateTime.new(1970, 11, 29)..DateTime.new(1970, 12, 27) },
      { value: 12, dates: DateTime.new(1970, 12, 28)..DateTime.new(1970, 12, 31) },

      { value: 12, dates: DateTime.new(1971, 1, 1)..DateTime.new(1971, 1, 26) }, # 1971
      { value: 1, dates: DateTime.new(1971, 1, 27)..DateTime.new(1971, 2, 24) },
      { value: 2, dates: DateTime.new(1971, 2, 25)..DateTime.new(1971, 3, 26) },
      { value: 3, dates: DateTime.new(1971, 3, 27)..DateTime.new(1971, 4, 24) },
      { value: 4, dates: DateTime.new(1971, 4, 25)..DateTime.new(1971, 5, 23) },
      { value: 5, dates: DateTime.new(1971, 5, 24)..DateTime.new(1971, 6, 22) },
      { value: 5, dates: DateTime.new(1971, 6, 23)..DateTime.new(1971, 7, 21) },
      { value: 6, dates: DateTime.new(1971, 7, 22)..DateTime.new(1971, 8, 20) },
      { value: 7, dates: DateTime.new(1971, 8, 21)..DateTime.new(1971, 9, 18) },
      { value: 8, dates: DateTime.new(1971, 9, 19)..DateTime.new(1971, 10, 18) },
      { value: 9, dates: DateTime.new(1971, 10, 19)..DateTime.new(1971, 11, 17) },
      { value: 10, dates: DateTime.new(1971, 11, 18)..DateTime.new(1971, 12, 17) },
      { value: 11, dates: DateTime.new(1971, 12, 18)..DateTime.new(1971, 12, 31) },

      { value: 11, dates: DateTime.new(1972, 1, 1)..DateTime.new(1972, 1, 15) }, # 1972
      { value: 12, dates: DateTime.new(1972, 1, 16)..DateTime.new(1972, 2, 14) },
      { value: 1, dates: DateTime.new(1972, 2, 15)..DateTime.new(1972, 3, 14) },
      { value: 2, dates: DateTime.new(1972, 3, 15)..DateTime.new(1972, 4, 13) },
      { value: 3, dates: DateTime.new(1972, 4, 14)..DateTime.new(1972, 5, 12) },
      { value: 4, dates: DateTime.new(1972, 5, 13)..DateTime.new(1972, 6, 10) },
      { value: 5, dates: DateTime.new(1972, 6, 11)..DateTime.new(1972, 7, 10) },
      { value: 6, dates: DateTime.new(1972, 7, 11)..DateTime.new(1972, 8, 8) },
      { value: 7, dates: DateTime.new(1972, 8, 9)..DateTime.new(1972, 9, 7) },
      { value: 8, dates: DateTime.new(1972, 9, 8)..DateTime.new(1972, 10, 6) },
      { value: 9, dates: DateTime.new(1972, 10, 7)..DateTime.new(1972, 11, 5) },
      { value: 10, dates: DateTime.new(1972, 11, 6)..DateTime.new(1972, 12, 5) },
      { value: 11, dates: DateTime.new(1972, 12, 6)..DateTime.new(1972, 12, 31) },

      { value: 11, dates: DateTime.new(1973, 1, 1)..DateTime.new(1973, 1, 3) },  # 1973
      { value: 12, dates: DateTime.new(1973, 1, 4)..DateTime.new(1973, 2, 2) },
      { value: 1, dates: DateTime.new(1973, 2, 3)..DateTime.new(1973, 3, 4) },
      { value: 2, dates: DateTime.new(1973, 3, 5)..DateTime.new(1973, 4, 2) },
      { value: 3, dates: DateTime.new(1973, 4, 3)..DateTime.new(1973, 5, 2) },
      { value: 4, dates: DateTime.new(1973, 5, 3)..DateTime.new(1973, 5, 31) },
      { value: 5, dates: DateTime.new(1973, 6, 1)..DateTime.new(1973, 6, 29) },
      { value: 6, dates: DateTime.new(1973, 6, 30)..DateTime.new(1973, 7, 29) },
      { value: 7, dates: DateTime.new(1973, 7, 30)..DateTime.new(1973, 8, 27) },
      { value: 8, dates: DateTime.new(1973, 8, 28)..DateTime.new(1973, 9, 25) },
      { value: 9, dates: DateTime.new(1973, 9, 26)..DateTime.new(1973, 10, 25) },
      { value: 10, dates: DateTime.new(1973, 10, 26)..DateTime.new(1973, 11, 24) },
      { value: 11, dates: DateTime.new(1973, 11, 25)..DateTime.new(1973, 12, 23) },
      { value: 12, dates: DateTime.new(1973, 12, 24)..DateTime.new(1973, 12, 31) },

      { value: 12, dates: DateTime.new(1974, 1, 1)..DateTime.new(1974, 1, 22) }, # it's 1973 !!!
      { value: 1, dates: DateTime.new(1974, 1, 23)..DateTime.new(1974, 2, 21) },# 1974
      { value: 2, dates: DateTime.new(1974, 2, 22)..DateTime.new(1974, 3, 23) },
      { value: 3, dates: DateTime.new(1974, 3, 24)..DateTime.new(1974, 4, 21) },
      { value: 4, dates: DateTime.new(1974, 4, 22)..DateTime.new(1974, 5, 21) },
      { value: 4, dates: DateTime.new(1974, 5, 22)..DateTime.new(1974, 6, 19) }, # same 4th!
      { value: 5, dates: DateTime.new(1974, 6, 20)..DateTime.new(1974, 7, 18) },
      { value: 6, dates: DateTime.new(1974, 7, 19)..DateTime.new(1974, 8, 17) },
      { value: 7, dates: DateTime.new(1974, 8, 18)..DateTime.new(1974, 9, 15) },
      { value: 8, dates: DateTime.new(1974, 9, 16)..DateTime.new(1974, 10, 14) },
      { value: 9, dates: DateTime.new(1974, 10, 15)..DateTime.new(1974, 11, 13) },
      { value: 10, dates: DateTime.new(1974, 11, 14)..DateTime.new(1974, 12, 13) },
      { value: 11, dates: DateTime.new(1974, 12, 14)..DateTime.new(1974, 12, 31) },

      { value: 11, dates: DateTime.new(1975, 1, 1)..DateTime.new(1975, 1, 11) }, # 1975
      { value: 12, dates: DateTime.new(1975, 1, 12)..DateTime.new(1975, 2, 10) },
      { value: 1, dates: DateTime.new(1975, 2, 11)..DateTime.new(1975, 3, 12) },
      { value: 2, dates: DateTime.new(1975, 3, 13)..DateTime.new(1975, 4, 11) },
      { value: 3, dates: DateTime.new(1975, 4, 12)..DateTime.new(1975, 5, 10) },
      { value: 4, dates: DateTime.new(1975, 5, 11)..DateTime.new(1975, 6, 9) },
      { value: 5, dates: DateTime.new(1975, 6, 10)..DateTime.new(1975, 7, 8) },
      { value: 6, dates: DateTime.new(1975, 7, 9)..DateTime.new(1975, 8, 6) },
      { value: 7, dates: DateTime.new(1975, 8, 7)..DateTime.new(1975, 9, 5) },
      { value: 8, dates: DateTime.new(1975, 9, 6)..DateTime.new(1975, 10, 4) },
      { value: 9, dates: DateTime.new(1975, 10, 5)..DateTime.new(1975, 11, 2) },
      { value: 10, dates: DateTime.new(1975, 11, 3)..DateTime.new(1975, 12, 2) },
      { value: 11, dates: DateTime.new(1975, 12, 3)..DateTime.new(1975, 12, 31) },

      { value: 12, dates: DateTime.new(1976, 1, 1)..DateTime.new(1976, 1, 30) }, # 1976
      { value: 1, dates: DateTime.new(1976, 1, 31)..DateTime.new(1976, 2, 29) },
      { value: 2, dates: DateTime.new(1976, 3, 1)..DateTime.new(1976, 3, 30) },
      { value: 3, dates: DateTime.new(1976, 3, 31)..DateTime.new(1976, 4, 28) },
      { value: 4, dates: DateTime.new(1976, 4, 29)..DateTime.new(1976, 5, 28) },
      { value: 5, dates: DateTime.new(1976, 5, 29)..DateTime.new(1976, 6, 26) },
      { value: 6, dates: DateTime.new(1976, 6, 27)..DateTime.new(1976, 7, 26) },
      { value: 7, dates: DateTime.new(1976, 7, 27)..DateTime.new(1976, 8, 24) },
      { value: 8, dates: DateTime.new(1976, 8, 25)..DateTime.new(1976, 9, 23) },
      { value: 8, dates: DateTime.new(1976, 9, 24)..DateTime.new(1976, 10, 22) }, # the same 8th !
      { value: 9, dates: DateTime.new(1976, 10, 23)..DateTime.new(1976, 11, 20) },
      { value: 10, dates: DateTime.new(1976, 11, 21)..DateTime.new(1976, 12, 20) },
      { value: 11, dates: DateTime.new(1976, 12, 21)..DateTime.new(1976, 12, 31) },

      { value: 11, dates: DateTime.new(1977, 1, 1)..DateTime.new(1977, 1, 18) }, # 1977
      { value: 12, dates: DateTime.new(1977, 1, 19)..DateTime.new(1977, 2, 17) },
      { value: 1, dates: DateTime.new(1977, 2, 18)..DateTime.new(1977, 3, 19) },
      { value: 2, dates: DateTime.new(1977, 3, 20)..DateTime.new(1977, 4, 17) },
      { value: 3, dates: DateTime.new(1977, 4, 18)..DateTime.new(1977, 5, 17) },
      { value: 4, dates: DateTime.new(1977, 5, 18)..DateTime.new(1977, 6, 16) },
      { value: 5, dates: DateTime.new(1977, 6, 17)..DateTime.new(1977, 7, 15) },
      { value: 6, dates: DateTime.new(1977, 7, 16)..DateTime.new(1977, 8, 14) },
      { value: 7, dates: DateTime.new(1977, 8, 15)..DateTime.new(1977, 9, 12) },
      { value: 8, dates: DateTime.new(1977, 9, 13)..DateTime.new(1977, 10, 12) },
      { value: 9, dates: DateTime.new(1977, 10, 13)..DateTime.new(1977, 11, 10) },
      { value: 10, dates: DateTime.new(1977, 11, 11)..DateTime.new(1977, 12, 10) },
      { value: 11, dates: DateTime.new(1977, 12, 11)..DateTime.new(1977, 12, 31) },

      { value: 11, dates: DateTime.new(1978, 1, 1)..DateTime.new(1978, 1, 8) }, # 1978
      { value: 12, dates: DateTime.new(1978, 1, 9)..DateTime.new(1978, 2, 6) },
      { value: 1, dates: DateTime.new(1978, 2, 7)..DateTime.new(1978, 3, 8) },
      { value: 2, dates: DateTime.new(1978, 3, 9)..DateTime.new(1978, 4, 6) },
      { value: 3, dates: DateTime.new(1978, 4, 7)..DateTime.new(1978, 5, 6) },
      { value: 4, dates: DateTime.new(1978, 5, 7)..DateTime.new(1978, 6, 5) },
      { value: 5, dates: DateTime.new(1978, 6, 6)..DateTime.new(1978, 7, 4) },
      { value: 6, dates: DateTime.new(1978, 7, 5)..DateTime.new(1978, 8, 3) },
      { value: 7, dates: DateTime.new(1978, 8, 4)..DateTime.new(1978, 9, 2) },
      { value: 8, dates: DateTime.new(1978, 9, 3)..DateTime.new(1978, 10, 1) },
      { value: 9, dates: DateTime.new(1978, 10, 2)..DateTime.new(1978, 10, 31) },
      { value: 10, dates: DateTime.new(1978, 11, 1)..DateTime.new(1978, 11, 29) },
      { value: 11, dates: DateTime.new(1978, 11, 30)..DateTime.new(1978, 12, 29) },
      { value: 12, dates: DateTime.new(1978, 12, 30)..DateTime.new(1978, 12, 31) },

      { value: 12, dates: DateTime.new(1979, 1, 1)..DateTime.new(1979, 1, 27) }, #1979
      { value: 1, dates: DateTime.new(1979, 1, 28)..DateTime.new(1979, 2, 26) },
      { value: 2, dates: DateTime.new(1979, 2, 27)..DateTime.new(1979, 3, 27) },
      { value: 3, dates: DateTime.new(1979, 3, 28)..DateTime.new(1979, 4, 25) },
      { value: 4, dates: DateTime.new(1979, 4, 26)..DateTime.new(1979, 5, 25) },
      { value: 5, dates: DateTime.new(1979, 5, 26)..DateTime.new(1979, 6, 23) },
      { value: 6, dates: DateTime.new(1979, 6, 24)..DateTime.new(1979, 7, 23) },
      { value: 6, dates: DateTime.new(1979, 7, 24)..DateTime.new(1979, 8, 22) },
      { value: 7, dates: DateTime.new(1979, 8, 23)..DateTime.new(1979, 9, 20) },
      { value: 8, dates: DateTime.new(1979, 9, 21)..DateTime.new(1979, 10, 20) },
      { value: 9, dates: DateTime.new(1979, 10, 21)..DateTime.new(1979, 11, 19) },
      { value: 10, dates: DateTime.new(1979, 11, 20)..DateTime.new(1979, 12, 18) },
      { value: 11, dates: DateTime.new(1979, 12, 19)..DateTime.new(1979, 12, 31) },

      { value: 11, dates: DateTime.new(1980, 1, 1)..DateTime.new(1980, 1, 17) }, #1980
      { value: 12, dates: DateTime.new(1980, 1, 18)..DateTime.new(1980, 2, 15) },
      { value: 1, dates: DateTime.new(1980, 2, 16)..DateTime.new(1980, 3, 16) },
      { value: 2, dates: DateTime.new(1980, 3, 17)..DateTime.new(1980, 4, 14) },
      { value: 3, dates: DateTime.new(1980, 4, 15)..DateTime.new(1980, 5, 13) },
      { value: 4, dates: DateTime.new(1980, 5, 14)..DateTime.new(1980, 6, 12) },
      { value: 5, dates: DateTime.new(1980, 6, 13)..DateTime.new(1980, 7, 11) },
      { value: 6, dates: DateTime.new(1980, 7, 12)..DateTime.new(1980, 8, 10) },
      { value: 7, dates: DateTime.new(1980, 8, 11)..DateTime.new(1980, 9, 8) },
      { value: 8, dates: DateTime.new(1980, 9, 9)..DateTime.new(1980, 10, 8) },
      { value: 9, dates: DateTime.new(1980, 10, 9)..DateTime.new(1980, 11, 7) },
      { value: 10, dates: DateTime.new(1980, 11, 8)..DateTime.new(1980, 12, 6) },
      { value: 11, dates: DateTime.new(1980, 12, 7)..DateTime.new(1980, 12, 31) },

      { value: 11, dates: DateTime.new(1981, 1, 1)..DateTime.new(1981, 1, 5) }, #1981
      { value: 12, dates: DateTime.new(1981, 1, 6)..DateTime.new(1981, 2, 4) },
      { value: 1, dates: DateTime.new(1981, 2, 5)..DateTime.new(1981, 3, 5) },
      { value: 2, dates: DateTime.new(1981, 3, 6)..DateTime.new(1981, 4, 4) },
      { value: 3, dates: DateTime.new(1981, 4, 5)..DateTime.new(1981, 5, 3) },
      { value: 4, dates: DateTime.new(1981, 5, 4)..DateTime.new(1981, 6, 1) },
      { value: 5, dates: DateTime.new(1981, 6, 2)..DateTime.new(1981, 7, 1) },
      { value: 6, dates: DateTime.new(1981, 7, 2)..DateTime.new(1981, 7, 30) },
      { value: 7, dates: DateTime.new(1981, 7, 31)..DateTime.new(1981, 8, 28) },
      { value: 8, dates: DateTime.new(1981, 8, 29)..DateTime.new(1981, 9, 27) },
      { value: 9, dates: DateTime.new(1981, 9, 28)..DateTime.new(1981, 10, 27) },
      { value: 10, dates: DateTime.new(1981, 10, 28)..DateTime.new(1981, 11, 25) },
      { value: 11, dates: DateTime.new(1981, 11, 26)..DateTime.new(1981, 12, 25) },
      { value: 12, dates: DateTime.new(1981, 12, 26)..DateTime.new(1981, 12, 31) },

      { value: 12, dates: DateTime.new(1982, 1, 1)..DateTime.new(1982, 1, 24) }, #1982
      { value: 1, dates: DateTime.new(1982, 1, 25)..DateTime.new(1982, 2, 23) },
      { value: 2, dates: DateTime.new(1982, 2, 24)..DateTime.new(1982, 3, 24) },
      { value: 3, dates: DateTime.new(1982, 3, 25)..DateTime.new(1982, 4, 23) },
      { value: 4, dates: DateTime.new(1982, 4, 24)..DateTime.new(1982, 5, 22) },
      { value: 4, dates: DateTime.new(1982, 5, 23)..DateTime.new(1982, 6, 20) },
      { value: 5, dates: DateTime.new(1982, 6, 21)..DateTime.new(1982, 7, 20) },
      { value: 6, dates: DateTime.new(1982, 7, 21)..DateTime.new(1982, 8, 18) },
      { value: 7, dates: DateTime.new(1982, 8, 19)..DateTime.new(1982, 9, 16) },
      { value: 8, dates: DateTime.new(1982, 9, 17)..DateTime.new(1982, 10, 16) },
      { value: 9, dates: DateTime.new(1982, 10, 17)..DateTime.new(1982, 11, 14) },
      { value: 10, dates: DateTime.new(1982, 11, 15)..DateTime.new(1982, 12, 14) },
      { value: 11, dates: DateTime.new(1982, 12, 15)..DateTime.new(1982, 12, 31) },

      { value: 11, dates: DateTime.new(1983, 1, 1)..DateTime.new(1983, 1, 13) }, #1983
      { value: 12, dates: DateTime.new(1983, 1, 14)..DateTime.new(1983, 2, 12) },
      { value: 1, dates: DateTime.new(1983, 2, 13)..DateTime.new(1983, 3, 14) },
      { value: 2, dates: DateTime.new(1983, 3, 15)..DateTime.new(1983, 4, 12) },
      { value: 3, dates: DateTime.new(1983, 4, 13)..DateTime.new(1983, 5, 12) },
      { value: 4, dates: DateTime.new(1983, 5, 13)..DateTime.new(1983, 6, 10) },
      { value: 5, dates: DateTime.new(1983, 6, 11)..DateTime.new(1983, 7, 9) },
      { value: 6, dates: DateTime.new(1983, 7, 10)..DateTime.new(1983, 8, 8) },
      { value: 7, dates: DateTime.new(1983, 8, 9)..DateTime.new(1983, 9, 6) },
      { value: 8, dates: DateTime.new(1983, 9, 7)..DateTime.new(1983, 10, 5) },
      { value: 9, dates: DateTime.new(1983, 10, 6)..DateTime.new(1983, 11, 4) },
      { value: 10, dates: DateTime.new(1983, 11, 5)..DateTime.new(1983, 12, 3) },
      { value: 11, dates: DateTime.new(1983, 12, 4)..DateTime.new(1983, 12, 31) },

      { value: 11, dates: DateTime.new(1984, 1, 1)..DateTime.new(1984, 1, 2) }, #1984
      { value: 12, dates: DateTime.new(1984, 1, 3)..DateTime.new(1984, 2, 1) },
      { value: 1, dates: DateTime.new(1984, 2, 2)..DateTime.new(1984, 3, 2) },
      { value: 2, dates: DateTime.new(1984, 3, 3)..DateTime.new(1984, 3, 31) },
      { value: 3, dates: DateTime.new(1984, 4, 1)..DateTime.new(1984, 4, 30) },
      { value: 4, dates: DateTime.new(1984, 5, 1)..DateTime.new(1984, 5, 30) },
      { value: 5, dates: DateTime.new(1984, 5, 31)..DateTime.new(1984, 6, 28) },
      { value: 6, dates: DateTime.new(1984, 6, 29)..DateTime.new(1984, 7, 27) },
      { value: 7, dates: DateTime.new(1984, 7, 28)..DateTime.new(1984, 8, 26) },
      { value: 8, dates: DateTime.new(1984, 8, 27)..DateTime.new(1984, 9, 24) },
      { value: 9, dates: DateTime.new(1984, 9, 25)..DateTime.new(1984, 10, 23) },
      { value: 10, dates: DateTime.new(1984, 10, 24)..DateTime.new(1984, 11, 22) },
      { value: 10, dates: DateTime.new(1984, 11, 23)..DateTime.new(1984, 12, 21) },
      { value: 11, dates: DateTime.new(1984, 12, 22)..DateTime.new(1984, 12, 31) },

      { value: 11, dates: DateTime.new(1985, 1, 1)..DateTime.new(1985, 1, 20) }, #1985
      { value: 12, dates: DateTime.new(1985, 1, 21)..DateTime.new(1985, 2, 19) },
      { value: 1, dates: DateTime.new(1985, 2, 20)..DateTime.new(1985, 3, 20) },
      { value: 2, dates: DateTime.new(1985, 3, 21)..DateTime.new(1985, 4, 19) },
      { value: 3, dates: DateTime.new(1985, 4, 20)..DateTime.new(1985, 5, 19) },
      { value: 4, dates: DateTime.new(1985, 5, 20)..DateTime.new(1985, 6, 17) },
      { value: 5, dates: DateTime.new(1985, 6, 18)..DateTime.new(1985, 7, 17) },
      { value: 6, dates: DateTime.new(1985, 7, 18)..DateTime.new(1985, 8, 15) },
      { value: 7, dates: DateTime.new(1985, 8, 16)..DateTime.new(1985, 9, 14) },
      { value: 8, dates: DateTime.new(1985, 9, 15)..DateTime.new(1985, 10, 13) },
      { value: 9, dates: DateTime.new(1985, 10, 14)..DateTime.new(1985, 11, 11) },
      { value: 10, dates: DateTime.new(1985, 11, 12)..DateTime.new(1985, 12, 11) },
      { value: 11, dates: DateTime.new(1985, 12, 12)..DateTime.new(1985, 12, 31) },

      { value: 11, dates: DateTime.new(1986, 1, 1)..DateTime.new(1986, 1, 9) }, # 1986
      { value: 12, dates: DateTime.new(1986, 1, 10)..DateTime.new(1986, 2, 8) },
      { value: 1, dates: DateTime.new(1986, 2, 9)..DateTime.new(1986, 3, 9) },
      { value: 2, dates: DateTime.new(1986, 3, 10)..DateTime.new(1986, 4, 8) },
      { value: 3, dates: DateTime.new(1986, 4, 9)..DateTime.new(1986, 5, 8) },
      { value: 4, dates: DateTime.new(1986, 5, 9)..DateTime.new(1986, 6, 6) },
      { value: 5, dates: DateTime.new(1986, 6, 7)..DateTime.new(1986, 7, 6) },
      { value: 6, dates: DateTime.new(1986, 7, 7)..DateTime.new(1986, 8, 5) },
      { value: 7, dates: DateTime.new(1986, 8, 6)..DateTime.new(1986, 9, 3) },
      { value: 8, dates: DateTime.new(1986, 9, 4)..DateTime.new(1986, 10, 3) },
      { value: 9, dates: DateTime.new(1986, 10, 4)..DateTime.new(1986, 11, 1) },
      { value: 10, dates: DateTime.new(1986, 11, 2)..DateTime.new(1986, 12, 1) },
      { value: 11, dates: DateTime.new(1986, 12, 2)..DateTime.new(1986, 12, 30) },
      { value: 12, dates: DateTime.new(1986, 12, 31)..DateTime.new(1986, 12, 31) },

      { value: 12, dates: DateTime.new(1987, 1, 1)..DateTime.new(1987, 1, 28) }, # 1987
      { value: 1, dates: DateTime.new(1987, 1, 29)..DateTime.new(1987, 2, 27) },
      { value: 2, dates: DateTime.new(1987, 2, 28)..DateTime.new(1987, 3, 28) },
      { value: 3, dates: DateTime.new(1987, 3, 29)..DateTime.new(1987, 4, 27) },
      { value: 4, dates: DateTime.new(1987, 4, 28)..DateTime.new(1987, 5, 26) },
      { value: 5, dates: DateTime.new(1987, 5, 27)..DateTime.new(1987, 6, 25) },
      { value: 6, dates: DateTime.new(1987, 6, 26)..DateTime.new(1987, 7, 25) },
      { value: 6, dates: DateTime.new(1987, 7, 26)..DateTime.new(1987, 8, 23) },
      { value: 7, dates: DateTime.new(1987, 8, 24)..DateTime.new(1987, 9, 22) },
      { value: 8, dates: DateTime.new(1987, 9, 23)..DateTime.new(1987, 10, 22) },
      { value: 9, dates: DateTime.new(1987, 10, 23)..DateTime.new(1987, 11, 20) },
      { value: 10, dates: DateTime.new(1987, 11, 21)..DateTime.new(1987, 12, 20) },
      { value: 11, dates: DateTime.new(1987, 12, 21)..DateTime.new(1987, 12, 31) },

      { value: 11, dates: DateTime.new(1988, 1, 1)..DateTime.new(1988, 1, 18) }, # 1988
      { value: 12, dates: DateTime.new(1988, 1, 19)..DateTime.new(1988, 2, 16) },
      { value: 1, dates: DateTime.new(1988, 2, 17)..DateTime.new(1988, 3, 17) },
      { value: 2, dates: DateTime.new(1988, 3, 18)..DateTime.new(1988, 4, 15) },
      { value: 3, dates: DateTime.new(1988, 4, 16)..DateTime.new(1988, 5, 15) },
      { value: 4, dates: DateTime.new(1988, 5, 16)..DateTime.new(1988, 6, 13) },
      { value: 5, dates: DateTime.new(1988, 6, 14)..DateTime.new(1988, 7, 13) },
      { value: 6, dates: DateTime.new(1988, 7, 14)..DateTime.new(1988, 8, 11) },
      { value: 7, dates: DateTime.new(1988, 8, 12)..DateTime.new(1988, 9, 10) },
      { value: 8, dates: DateTime.new(1988, 9, 11)..DateTime.new(1988, 10, 10) },
      { value: 9, dates: DateTime.new(1988, 10, 11)..DateTime.new(1988, 11, 8) },
      { value: 10, dates: DateTime.new(1988, 11, 9)..DateTime.new(1988, 12, 8) },
      { value: 11, dates: DateTime.new(1988, 12, 9)..DateTime.new(1988, 12, 31) },

      { value: 11, dates: DateTime.new(1989, 1, 1)..DateTime.new(1989, 1, 7) }, # 1989
      { value: 12, dates: DateTime.new(1989, 1, 8)..DateTime.new(1989, 2, 5) },
      { value: 1, dates: DateTime.new(1989, 2, 6)..DateTime.new(1989, 3, 7) },
      { value: 2, dates: DateTime.new(1989, 3, 8)..DateTime.new(1989, 4, 5) },
      { value: 3, dates: DateTime.new(1989, 4, 6)..DateTime.new(1989, 5, 4) },
      { value: 4, dates: DateTime.new(1989, 5, 5)..DateTime.new(1989, 6, 3) },
      { value: 5, dates: DateTime.new(1989, 6, 4)..DateTime.new(1989, 7, 2) },
      { value: 6, dates: DateTime.new(1989, 7, 3)..DateTime.new(1989, 8, 1) },
      { value: 7, dates: DateTime.new(1989, 8, 2)..DateTime.new(1989, 8, 30) },
      { value: 8, dates: DateTime.new(1989, 8, 31)..DateTime.new(1989, 9, 29) },
      { value: 9, dates: DateTime.new(1989, 9, 30)..DateTime.new(1989, 10, 28) },
      { value: 10, dates: DateTime.new(1989, 10, 29)..DateTime.new(1989, 11, 27) },
      { value: 11, dates: DateTime.new(1989, 11, 28)..DateTime.new(1989, 12, 27) },
      { value: 12, dates: DateTime.new(1989, 12, 28)..DateTime.new(1989, 12, 31) },

      { value: 12, dates: DateTime.new(1990, 1, 1)..DateTime.new(1990, 1, 26) }, # 1990
      { value: 1, dates: DateTime.new(1990, 1, 27)..DateTime.new(1990, 2, 24) },
      { value: 2, dates: DateTime.new(1990, 2, 25)..DateTime.new(1990, 3, 26) },
      { value: 3, dates: DateTime.new(1990, 3, 27)..DateTime.new(1990, 4, 24) },
      { value: 4, dates: DateTime.new(1990, 4, 25)..DateTime.new(1990, 5, 23) },
      { value: 5, dates: DateTime.new(1990, 5, 24)..DateTime.new(1990, 6, 22) },
      { value: 5, dates: DateTime.new(1990, 6, 23)..DateTime.new(1990, 7, 21) },
      { value: 6, dates: DateTime.new(1990, 7, 22)..DateTime.new(1990, 8, 19) },
      { value: 7, dates: DateTime.new(1990, 8, 20)..DateTime.new(1990, 9, 18) },
      { value: 8, dates: DateTime.new(1990, 9, 19)..DateTime.new(1990, 10, 17) },
      { value: 9, dates: DateTime.new(1990, 10, 18)..DateTime.new(1990, 11, 16) },
      { value: 10, dates: DateTime.new(1990, 11, 17)..DateTime.new(1990, 12, 16) },
      { value: 11, dates: DateTime.new(1990, 12, 17)..DateTime.new(1990, 12, 31) },

      { value: 11, dates: DateTime.new(1991, 1, 1)..DateTime.new(1991, 1, 15) },# 1991
      { value: 12, dates: DateTime.new(1991, 1, 16)..DateTime.new(1991, 2, 14) },
      { value: 1, dates: DateTime.new(1991, 2, 15)..DateTime.new(1991, 3, 15) },
      { value: 2, dates: DateTime.new(1991, 3, 16)..DateTime.new(1991, 4, 14) },
      { value: 3, dates: DateTime.new(1991, 4, 15)..DateTime.new(1991, 5, 13) },
      { value: 4, dates: DateTime.new(1991, 5, 14)..DateTime.new(1991, 6, 11) },
      { value: 5, dates: DateTime.new(1991, 6, 12)..DateTime.new(1991, 7, 11) },
      { value: 6, dates: DateTime.new(1991, 7, 12)..DateTime.new(1991, 8, 9) },
      { value: 7, dates: DateTime.new(1991, 8, 10)..DateTime.new(1991, 9, 7) },
      { value: 8, dates: DateTime.new(1991, 9, 8)..DateTime.new(1991, 10, 7) },
      { value: 9, dates: DateTime.new(1991, 10, 8)..DateTime.new(1991, 11, 5) },
      { value: 10, dates: DateTime.new(1991, 11, 6)..DateTime.new(1991, 12, 5) },
      { value: 11, dates: DateTime.new(1991, 12, 6)..DateTime.new(1991, 12, 31) },

      { value: 11, dates: DateTime.new(1992, 1, 1)..DateTime.new(1992, 1, 4) }, # 1992
      { value: 12, dates: DateTime.new(1992, 1, 5)..DateTime.new(1992, 2, 3) },
      { value: 1, dates: DateTime.new(1992, 2, 4)..DateTime.new(1992, 3, 3) },
      { value: 2, dates: DateTime.new(1992, 3, 4)..DateTime.new(1992, 4, 2) },
      { value: 3, dates: DateTime.new(1992, 4, 3)..DateTime.new(1992, 5, 2) },
      { value: 4, dates: DateTime.new(1992, 5, 3)..DateTime.new(1992, 5, 31) },
      { value: 5, dates: DateTime.new(1992, 6, 1)..DateTime.new(1992, 6, 29) },
      { value: 6, dates: DateTime.new(1992, 6, 30)..DateTime.new(1992, 7, 29) },
      { value: 7, dates: DateTime.new(1992, 7, 30)..DateTime.new(1992, 8, 27) },
      { value: 8, dates: DateTime.new(1992, 8, 28)..DateTime.new(1992, 9, 25) },
      { value: 9, dates: DateTime.new(1992, 9, 26)..DateTime.new(1992, 10, 25) },
      { value: 10, dates: DateTime.new(1992, 10, 26)..DateTime.new(1992, 11, 23) },
      { value: 11, dates: DateTime.new(1992, 11, 24)..DateTime.new(1992, 12, 23) },
      { value: 12, dates: DateTime.new(1992, 12, 24)..DateTime.new(1992, 12, 31) },

      { value: 12, dates: DateTime.new(1993, 1, 1)..DateTime.new(1993, 1, 22) },# 1993
      { value: 1, dates: DateTime.new(1993, 1, 23)..DateTime.new(1993, 2, 20) },
      { value: 2, dates: DateTime.new(1993, 2, 21)..DateTime.new(1993, 3, 22) },
      { value: 3, dates: DateTime.new(1993, 3, 23)..DateTime.new(1993, 4, 21) },
      { value: 3, dates: DateTime.new(1993, 4, 22)..DateTime.new(1993, 5, 20) },
      { value: 4, dates: DateTime.new(1993, 5, 21)..DateTime.new(1993, 6, 19) },
      { value: 5, dates: DateTime.new(1993, 6, 20)..DateTime.new(1993, 7, 18) },
      { value: 6, dates: DateTime.new(1993, 7, 19)..DateTime.new(1993, 8, 17) },
      { value: 7, dates: DateTime.new(1993, 8, 18)..DateTime.new(1993, 9, 15) },
      { value: 8, dates: DateTime.new(1993, 9, 16)..DateTime.new(1993, 10, 14) },
      { value: 9, dates: DateTime.new(1993, 10, 15)..DateTime.new(1993, 11, 13) },
      { value: 10, dates: DateTime.new(1993, 11, 14)..DateTime.new(1993, 12, 12) },
      { value: 11, dates: DateTime.new(1993, 12, 13)..DateTime.new(1993, 12, 31) },

      { value: 11, dates: DateTime.new(1994, 1, 1)..DateTime.new(1994, 1, 11) }, # 1994
      { value: 12, dates: DateTime.new(1994, 1, 12)..DateTime.new(1994, 2, 9) },
      { value: 1, dates: DateTime.new(1994, 2, 10)..DateTime.new(1994, 3, 11) },
      { value: 2, dates: DateTime.new(1994, 3, 12)..DateTime.new(1994, 4, 10) },
      { value: 3, dates: DateTime.new(1994, 4, 11)..DateTime.new(1994, 5, 10) },
      { value: 4, dates: DateTime.new(1994, 5, 11)..DateTime.new(1994, 6, 8) },
      { value: 5, dates: DateTime.new(1994, 6, 9)..DateTime.new(1994, 7, 8) },
      { value: 6, dates: DateTime.new(1994, 7, 9)..DateTime.new(1994, 8, 6) },
      { value: 7, dates: DateTime.new(1994, 8, 7)..DateTime.new(1994, 9, 5) },
      { value: 8, dates: DateTime.new(1994, 9, 6)..DateTime.new(1994, 10, 4) },
      { value: 9, dates: DateTime.new(1994, 10, 5)..DateTime.new(1994, 11, 2) },
      { value: 10, dates: DateTime.new(1994, 11, 3)..DateTime.new(1994, 12, 2) },
      { value: 11, dates: DateTime.new(1994, 12, 3)..DateTime.new(1994, 12, 31) },

      { value: 12, dates: DateTime.new(1995, 1, 1)..DateTime.new(1995, 1, 30) },# 1995
      { value: 1, dates: DateTime.new(1995, 1, 31)..DateTime.new(1995, 2, 28) },
      { value: 2, dates: DateTime.new(1995, 3, 1)..DateTime.new(1995, 3, 30) },
      { value: 3, dates: DateTime.new(1995, 3, 31)..DateTime.new(1995, 4, 29) },
      { value: 4, dates: DateTime.new(1995, 4, 30)..DateTime.new(1995, 5, 28) },
      { value: 5, dates: DateTime.new(1995, 5, 29)..DateTime.new(1995, 6, 27) },
      { value: 6, dates: DateTime.new(1995, 6, 28)..DateTime.new(1995, 7, 26) },
      { value: 7, dates: DateTime.new(1995, 7, 27)..DateTime.new(1995, 8, 25) },
      { value: 8, dates: DateTime.new(1995, 8, 26)..DateTime.new(1995, 9, 24) },
      { value: 8, dates: DateTime.new(1995, 9, 25)..DateTime.new(1995, 10, 23) },
      { value: 9, dates: DateTime.new(1995, 10, 24)..DateTime.new(1995, 11, 21) },
      { value: 10, dates: DateTime.new(1995, 11, 22)..DateTime.new(1995, 12, 21) },
      { value: 11, dates: DateTime.new(1995, 12, 22)..DateTime.new(1995, 12, 31) },

      { value: 11, dates: DateTime.new(1996, 1, 1)..DateTime.new(1996, 1, 19) }, # 1996
      { value: 12, dates: DateTime.new(1996, 1, 20)..DateTime.new(1996, 2, 18) },
      { value: 1, dates: DateTime.new(1996, 2, 19)..DateTime.new(1996, 3, 18) },
      { value: 2, dates: DateTime.new(1996, 3, 19)..DateTime.new(1996, 4, 17) },
      { value: 3, dates: DateTime.new(1996, 4, 18)..DateTime.new(1996, 5, 16) },
      { value: 4, dates: DateTime.new(1996, 5, 17)..DateTime.new(1996, 6, 15) },
      { value: 5, dates: DateTime.new(1996, 6, 16)..DateTime.new(1996, 7, 15) },
      { value: 6, dates: DateTime.new(1996, 7, 16)..DateTime.new(1996, 8, 13) },
      { value: 7, dates: DateTime.new(1996, 8, 14)..DateTime.new(1996, 9, 12) },
      { value: 8, dates: DateTime.new(1996, 9, 13)..DateTime.new(1996, 10, 11) },
      { value: 9, dates: DateTime.new(1996, 10, 12)..DateTime.new(1996, 11, 10) },
      { value: 10, dates: DateTime.new(1996, 11, 11)..DateTime.new(1996, 12, 10) },
      { value: 11, dates: DateTime.new(1996, 12, 11)..DateTime.new(1996, 12, 31) },

      { value: 11, dates: DateTime.new(1997, 1, 1)..DateTime.new(1997, 1, 8) }, # 1997
      { value: 12, dates: DateTime.new(1997, 1, 9)..DateTime.new(1997, 2, 6) },
      { value: 1, dates: DateTime.new(1997, 2, 7)..DateTime.new(1997, 3, 8) },
      { value: 2, dates: DateTime.new(1997, 3, 9)..DateTime.new(1997, 4, 6) },
      { value: 3, dates: DateTime.new(1997, 4, 7)..DateTime.new(1997, 5, 6) },
      { value: 4, dates: DateTime.new(1997, 5, 7)..DateTime.new(1997, 6, 4) },
      { value: 5, dates: DateTime.new(1997, 6, 5)..DateTime.new(1997, 7, 4) },
      { value: 6, dates: DateTime.new(1997, 7, 5)..DateTime.new(1997, 8, 2) },
      { value: 7, dates: DateTime.new(1997, 8, 3)..DateTime.new(1997, 9, 1) },
      { value: 8, dates: DateTime.new(1997, 9, 2)..DateTime.new(1997, 10, 1) },
      { value: 9, dates: DateTime.new(1997, 10, 2)..DateTime.new(1997, 10, 30) },
      { value: 10, dates: DateTime.new(1997, 10, 31)..DateTime.new(1997, 11, 29) },
      { value: 11, dates: DateTime.new(1997, 11, 30)..DateTime.new(1997, 12, 29) },
      { value: 12, dates: DateTime.new(1997, 12, 30)..DateTime.new(1997, 12, 31) },

      { value: 12, dates: DateTime.new(1998, 1, 1)..DateTime.new(1998, 1, 27) }, # 1998
      { value: 1, dates: DateTime.new(1998, 1, 28)..DateTime.new(1998, 2, 26) },
      { value: 2, dates: DateTime.new(1998, 2, 27)..DateTime.new(1998, 3, 27) },
      { value: 3, dates: DateTime.new(1998, 3, 28)..DateTime.new(1998, 4, 25) },
      { value: 4, dates: DateTime.new(1998, 4, 26)..DateTime.new(1998, 5, 25) },
      { value: 5, dates: DateTime.new(1998, 2, 26)..DateTime.new(1998, 6, 23) },
      { value: 5, dates: DateTime.new(1998, 6, 24)..DateTime.new(1998, 7, 22) },
      { value: 6, dates: DateTime.new(1998, 7, 23)..DateTime.new(1998, 8, 21) },
      { value: 7, dates: DateTime.new(1998, 8, 22)..DateTime.new(1998, 9, 20) },
      { value: 8, dates: DateTime.new(1998, 9, 21)..DateTime.new(1998, 10, 19) },
      { value: 9, dates: DateTime.new(1998, 10, 20)..DateTime.new(1998, 11, 18) },
      { value: 10, dates: DateTime.new(1998, 11, 19)..DateTime.new(1998, 12, 18) },
      { value: 11, dates: DateTime.new(1998, 12, 19)..DateTime.new(1998, 12, 31) },

      { value: 11, dates: DateTime.new(1999, 1, 1)..DateTime.new(1999, 1, 16) }, # 1999
      { value: 12, dates: DateTime.new(1999, 1, 17)..DateTime.new(1999, 2, 15) },
      { value: 1, dates: DateTime.new(1999, 2, 16)..DateTime.new(1999, 3, 17) },
      { value: 2, dates: DateTime.new(1999, 3, 18)..DateTime.new(1999, 4, 15) },
      { value: 3, dates: DateTime.new(1999, 4, 16)..DateTime.new(1999, 5, 14) },
      { value: 4, dates: DateTime.new(1999, 5, 15)..DateTime.new(1999, 6, 13) },
      { value: 5, dates: DateTime.new(1999, 6, 14)..DateTime.new(1999, 7, 12) },
      { value: 6, dates: DateTime.new(1999, 7, 13)..DateTime.new(1999, 8, 10) },
      { value: 7, dates: DateTime.new(1999, 8, 11)..DateTime.new(1999, 9, 9) },
      { value: 8, dates: DateTime.new(1999, 9, 10)..DateTime.new(1999, 10, 8) },
      { value: 9, dates: DateTime.new(1999, 10, 9)..DateTime.new(1999, 11, 7) },
      { value: 10, dates: DateTime.new(1999, 11, 8)..DateTime.new(1999, 12, 7) },
      { value: 11, dates: DateTime.new(1999, 12, 8)..DateTime.new(1999, 12, 31) },

      { value: 11, dates: DateTime.new(2000, 1, 1)..DateTime.new(2000, 1, 6) }, # 2000
      { value: 12, dates: DateTime.new(2000, 1, 7)..DateTime.new(2000, 2, 4) },
      { value: 1, dates: DateTime.new(2000, 2, 5)..DateTime.new(2000, 3, 5) },
      { value: 2, dates: DateTime.new(2000, 3, 6)..DateTime.new(2000, 4, 4) },
      { value: 3, dates: DateTime.new(2000, 4, 5)..DateTime.new(2000, 5, 3) },
      { value: 4, dates: DateTime.new(2000, 5, 4)..DateTime.new(2000, 6, 1) },
      { value: 5, dates: DateTime.new(2000, 6, 2)..DateTime.new(2000, 7, 1) },
      { value: 6, dates: DateTime.new(2000, 7, 2)..DateTime.new(2000, 7, 30) },
      { value: 7, dates: DateTime.new(2000, 7, 31)..DateTime.new(2000, 8, 28) },
      { value: 8, dates: DateTime.new(2000, 8, 29)..DateTime.new(2000, 9, 27) },
      { value: 9, dates: DateTime.new(2000, 9, 28)..DateTime.new(2000, 10, 26) },
      { value: 10, dates: DateTime.new(2000, 10, 27)..DateTime.new(2000, 11, 25) },
      { value: 11, dates: DateTime.new(2000, 11, 26)..DateTime.new(2000, 12, 25) },
      { value: 12, dates: DateTime.new(2000, 12, 26)..DateTime.new(2000, 12, 31) }
    ]
  end

  def patient_month_calculation(birth) # month's number from Hongcong observatotie's table
     ranges.find do |range|
      range[:dates].include?(birth.to_date)
    end
  end


  def first_point_lo_shu_number(year, month, day_p, day_d )
    s = (year + month + day_p + day_d)%64
    if s == 0
      s = 64
    else
      s
    end
  end

  #  получасие активного на момент ПРИЕМА ПАЦИЕНТА канала
  def half_hour_for_reception_time(hour:, min:)
    case hour
    when (0..23)
      if (0..29).include?(min)
        return half_hour_guard = hour*2 + 1
      end
        if (30..59).include?(min)
        return half_hour_guard = hour*2 + 2
      else
        'Incorrect time'
      end
      else
      'Incorrect time'
    end
  end

  def meridian_for_lo_shu_square(h)
    case h
      when 1, 13, 25, 37 then 9 # BLADDER, V
      when 2, 14, 26, 38 then 10 # KIDNEYS, R
      when 3, 15, 27, 39 then 11  # MC
      when 4, 16, 28, 40 then 12 # TR
      when 5, 17, 29, 41 then 11 # VB
      when 6, 18, 30, 42 then 2 # F
      when 7, 19, 31, 43 then 3 # P
      when 8, 20, 32, 44 then 4 # Gi
      when 9, 21, 33, 45 then 5 # E
      when 10, 22, 34, 46 then 6 # Rp
      when 11, 23, 35, 47 then 7   # C
      when 12, 24, 36, 48 then 8 # Ig small int
      end
  end

  def points_matrix_lo_shu(meridian_lo_shu)
    case meridian_lo_shu
      when 1
      gall_bladder =
      [
        { values: 21..24, points: 'VB.44(21) + MC.8(44), F.4(22) + TR.10(43),
          VB.43(23-bad) + MC.7(42-bad), F.3(24) + TR.6(41)' },
        { values: 41..44, points: 'MC.8(44) + VB.44(21), TR.10(43) + F.4(22),
          MC.7(42-bad) + VB.43(23-bad), TR.6(41) + F.3(24)' }, # mirror 21..24
        { values: 33..36, points: 'VB.41(33) + TR.3(32) ,P.11(34-bad) + MC.9(31-bad)
          VB.40(35) + TR.4(30), F.8 + R.10' },
        { values: 29..32, points: 'R.10(29) + F.8(36), TR.4(30) + VB.40(35),
          MC.9(31-bad) + P.11(34-bad), TR.3(32) + VB.41(33)' }, #mirror 33..36
        { values: 45..48, points: 'P.10(45) + R.3(20), VB.34(46) + TR.2(19),
          P.9(47) + R.7(18), VB.38(48) + TR.1(17)' },
        { values: 17..20, points: 'TR.1(17) + VB.38(48), R.7(18) + P.9(47),
          TR.2(19) + VB.34(46), R.3(20) + P.10(45)' }, # mirror 45..48
        { values: 25..28, points: 'P.8(25) + VC.5(40), F.2(26) + R.2(39),
          P.5(27) + MC.3(38), F.1(28) + R.1(37)' },
        { values: 37..40, points: 'R.1(37) + F.1(28), MC.3(38) + P.5(27),
          R.2(39) + F.2(26), MC.5(40) + P.8(25)' }, # mirror 25..28
        { values: 57..60, points: 'RP.9(57) + RP.3(8),  Ig.8(58) + E.44(7),
        C.7(59) + RP.5(6), Ig.5(60) + E.45(5) ' },
        { values: 5..8, points: 'E.45(5) + Ig.5(60), RP.5(6) + C.7(59),
          E.44(7) + Ig.8(58), RP.3(8) + RP.9(57)' }, # mirror 57..60
        { values: 13..16, points: 'C.4(13) + Gi.5(52), V.66(14) + RP.2(51),
          C.3(15) + Gi.11(50), V.67(16) + RP.1(49)' },
        { values: 49..52, points: 'RP.1(49) + V.67(16), Gi.11(50) + C.3(15),
          RP.2(51) + V.66(14), Gi.5(52) + C.4(13) ' }, # mirror 13..16
        { values: 1..4, points: 'V.65(1) + E.41(64), Ig.2(2) + Gi.4(63),
          V.64(3) + E.36(62), Ig.1(4) + Gi.3(61)' },
        { values: 61..64, points: 'Gi.3(61) + Ig.1(4), E.36(62) + V.64(3),
          Gi.4(63) + Ig.2(2), E.41(64) + V.65(1) ' }, # mirror 1..4
        { values: 53..56, points: 'V.60(53) + Gi.1(12), Ig.4-bad(54) + E.42-bad(11),
          V.40(55) + Gi.2(10), Ig.3(56) + E.43(9)' },
        { values: 9..12, points: 'E.43(9) + Ig.3(56), Gi.2(10) + V.40(55),
         E.42-bad(11) + Ig.4-bad(54), Gi.1(12) + V.60(53)' }, # mirror 53..56
      ]
      when 2
      liver =
      [
        { values: 21..24, points: 'F.1(21) + TR.3(44), P.5(22) + Vb.34(43),
          F.2(23-bad) + TR.4(42-bad), P.8(24) + VB.38(41)' },
        { values: 41..44, points: 'VB.38(41) + P.8(24), TR.4-bad(42) + F.2-bad(23),
          Vb.34(43) + P.5(22), TR.3(44) + F.1(21)' }, # mirror 21..24
        { values: 33..36, points: 'F.3(33) + Vb.41(32) ,Gi.2(34-bad) + TR.2(31-bad)
          F.4(35) + Vb.40(30), Gi.1(36) + TR.1(29)' },
        { values: 29..32, points: 'TR.1(29) + Gi.1(36), Vb.40(30) + F.4(35),
          TR.2-bad(31) + Gi.2-bad(34), Vb.41(32) + F.3(33)' }, #mirror 33..36
        { values: 45..48, points: 'Gi.3(45) + MC.5(20), P.11(46) + VB.43(19),
          Gi.4(47) + MC.3(18), F.8(48) + VB.44(17)' },
        { values: 17..20, points: 'VB.44(17) + F.8(48), MC.3(18) + Gi.4(47),
          VB.43(19) + P.11(46), MC.5(20) + Gi.3(45)' }, # mirror 45..48
        { values: 25..28, points: 'Gi.5(25) + TR.5(40), P.9(26) + MC.7(39),
          Gi.11(27) + TR.10(38), P.10(28) + MC.8(37)' },
        { values: 37..40, points: 'MC.8(37) + P.10(28), TR.10(38) + Gi.11(27),
          MC.7(39) + P.9(26), TR.5(40) + Gi.5(25)' }, # mirror 25..28
        { values: 57..60, points: 'Ig.3(57) + C.4(8), V.40(58) + Rp.2(7),
          Ig.4(59) + C.3(6), V.60(60) + Rp.1(5) ' },
        { values: 5..8, points: 'Rp.1(5) + V.60(60), C.3(6) + Ig.4(59),
          Rp.2(7) + V.40(58), C.4(8) + Ig.3(57)' }, # mirror 57..60
        { values: 13..16, points: 'Ig.5(13) + E.41(52), Rp.2(14) + C.7(51),
          Ig.8(15) + E.36(50), R.1(16) + C.8(49)' },
        { values: 49..52, points: 'C.8(49) + R.1(16), E.36(50) + Ig.8(15),
          C.7(51) + Rp.2(14), E.41(52) + Ig.5(13) ' }, # mirror 13..16
        { values: 1..4, points: 'R.3(1) + Rp.9(64), V.66(2) + E.42(63),
          R.7(3) + C.9(62), V.67(4) + E.43(61)' },
        { values: 61..64, points: 'E.43(61) + V.67(4), C.9(62) + R.7(3),
          E.42(63) + V.66(2), Rp.9(64) + R.3(1) ' }, # mirror 1..4
        { values: 53..56, points: 'R.10(53) + E.45(12), V.64-bad(54) + Rp.5-bad(11),
          MC.9(55) + E.44(10), V.65(56) + Rp.3(9)' },
        { values: 9..12, points: 'Rp.3(9) + V.65(56), E.44(10) + MC.9(55),
         Rp.5-bad(11) + V.64-bad(54), E.45(12) + R.10(53)' }, # mirror 53..56
      ]
      when 3
      lungs =
      [
        { values: 21..24, points: 'P.11(21) + VB.43(44), Gi.5(22) + F.8(43),
          P.10(23-bad) + Vb.41(42-bad), Gi.4(24) + F.4(41)' },
        { values: 41..44, points: 'F.4(41) + Gi.4(24), Vb.41(42-bad) + P.10(23-bad),
          F.8(43) + Gi.5(22), VB.43(44) + P.11(21),' }, # mirror 21..24
        { values: 33..36, points: 'P.9(33) + F.2(32) ,E.45(34-bad) + VB.44(31-bad)
          P.8(35) + F.3(30), Gi.11(36) + TR.10(29)' },
        { values: 29..32, points: 'TR.10(29) + Gi.11(36), F.3(30) + P.8(35),
          VB.44(31-bad) + E.45(34-bad), F.2(32) + P.9(33)' }, #mirror 33..36
        { values: 45..48, points: 'E.44(45) + TR.4(20), Gi.1(46) + F.1(19),
          E.43(47) + TR.6(18), P.5(48) + VB.34(17)' },
        { values: 17..20, points: 'VB.34(17) + P.5(48), TR.6(18) + E.43(47),
          F.1(19) + Gi.1(46), TR.4(20) + E.44(45)' }, # mirror 45..48
        { values: 25..28, points: 'E.42(25) + VB.40(40), Gi.3(26) + TR.3(39),
          E.41(27) + VB.38(38), Gi.2(28) + TR.2(37)' },
        { values: 37..40, points: 'TR.2(37) + Gi.2(28), VB.38(38) + E.41(27),
          TR.3(39) + Gi.3(26), VB.40(40) + E.42(25)' }, # mirror 25..28
        { values: 57..60, points: 'Ig.8(57) + Ig.4(8), R.10(58) + C.8(7),
          V.65(59) + Ig.5(6), R.7(60) + C.9(5) ' },
        { values: 5..8, points: 'C.9(5) + R.7(60), Ig.5(6) + V.65(59),
          C.8(7) + R.10(58), Ig.4(8) + Ig.8(57)' }, # mirror 57..60
        { values: 13..16, points: 'V.64(13) + Rp.5(52), MC.8(14) + Ig.3(51),
          V.60(15) + Rp.9(50), MC.9(16) + Ig.2(49)' },
        { values: 49..52, points: 'Ig.2(49) + MC.9(16), Rp.9(50) + V.60(15),
          Ig.3(51) + MC.8(14), Rp.5(52) + V.64(13) ' }, # mirror 13..16
        { values: 1..4, points: 'MC.7(1) + C.3(64), R.1(2) + Rp.3(63),
          MC.5(3) + Ig.1(62), V.40(4) + Rp.2(61)' },
        { values: 61..64, points: 'Rp.2(61) + V.40(4), Ig.1(62) + MC.5(3),
          Rp.3(63) + R.1(2), C.3(64) + MC.7(1) ' }, # mirror 1..4
        { values: 53..56, points: 'MC.3(53) + E.36(12), R.3-bad(54) + C.4-bad(11),
          TR.1(55) + Rp.1(10), R.2(56) + C.7(9)' },
        { values: 9..12, points: 'C.7(9) + R.2(56), Rp.1(10) + TR.1(55),
         C.4-bad(11) + R.3-bad(54), E.36(12) + MC.3(53)' }, # mirror 53..56
      ]
      when 4
      large_intestine =
      [
        { values: 21..24, points: 'Gi.1(21) + F.1(44), E.42(22) + P.5(43),
          Gi.2(23-bad) + F.2(42-bad), E.43(24) + P.8(41)' },
        { values: 41..44, points: 'P.8(41) + E.43(24), F.2(42-bad) + Gi.2(23-bad),
          P.5(43) + E.42(22), F.1(44) + Gi.1(21),' }, # mirror 21..24
        { values: 33..36, points: 'Gi.3(33) + P.10(32) , E.36(34-bad) + Vb.34(31-bad)
          Gi.4(35) + P.9(30), E.41(36) + Vb.38(29)' },
        { values: 29..32, points: 'Vb.38(29) + E.41(36), P.9(30) + Gi.4(35),
          Vb.34(31-bad) + E.36(34-bad), P.10(32) + Gi.3(33)' }, #mirror 33..36
        { values: 45..48, points: 'Rp.1(45) + Vb.41(20), Gi.11(46) + P.11(19),
          Rp.2(47) + Vb.40(18), Gi.5(48) + F.8(17)' },
        { values: 17..20, points: 'F.8(17) + Gi.5(48), Vb.40(18) + Rp.2(47),
          P.11(19) + Gi.11(46), Vb.41(20) + Rp.1(45)' }, # mirror 45..48
        { values: 25..28, points: 'Rp.3(25) + F.3(40), E.44(26) + Vb.43(39),
          Rp.5(27) + F.4(38), E.45(28) + Vb.44(37)' },
        { values: 37..40, points: 'Vb.44(37) + E.45(28), F.4(38) + Rp.5(27),
          Vb.43(39) + E.44(26), F.3(40) + Rp.3(25)' }, # mirror 25..28
        { values: 57..60, points: 'V.60(57) + V.65(8), MC.3(58) + Ig.2(7),
          V.40(59) + V.64(6), MC.5(60) + Ig.1(5) ' },
        { values: 5..8, points: 'Ig.1(5) + MC.5(60), V.64(6) + V.40(59),
          Ig.2(7) + MC.3(58), V.65(8) + V.60(57)' }, # mirror 57..60
        { values: 13..16, points: 'R.3(13) + C.4(52), TR.2(14) + V.66(51),
          R.7(15) + C.3(50), TR.1(16) + V.67(49)' },
        { values: 49..52, points: 'V.67(49) + TR.1(16), C.3(50) + R.7(15),
          V.66(51) + TR.2(14), C.4(52) + R.3(13) ' }, # mirror 13..16
        { values: 1..4, points: 'TR.3(1) + Ig.5(64), MC.9(2) + C.7(63),
          TR.4(3) + Ig.8(62), R.10(4) + C.8(61)' },
        { values: 61..64, points: 'C.8(61) + R.10(4), Ig.8(62) + TR.4(3),
          C.7(63) + MC.9(2), Ig.5(64) + TR.3(1) ' }, # mirror 1..4
        { values: 53..56, points: 'TR.6(53) + Rp.9(12), MC.7-bad(54) + Ig.4-bad(11),
          TR.10(55) + C.9(10), MC.8(56) + Ig.3(9)' },
        { values: 9..12, points: 'Ig.3(9) + MC.8(56), C.9(10) + TR.10(55),
         Ig.4-bad(11) + MC.7-bad(54), Rp.9(12) + TR.6(53)' }, # mirror 53..56
      ]
      when 5
      stomach =
      [
        { values: 21..24, points: 'E.45(21) + P.10(44), Rp.5(22) + Gi.11(43),
          E.44(23-bad) + P.9(42-bad), Rp.3(24) + Gi.5(41)' },
        { values: 41..44, points: 'Gi.5(41) + Rp.3(24), P.9(42-bad) + E.44(23-bad),
          Gi.11(43) + Rp.5(22), P.10(44) + E.45(21),' }, # mirror 21..24
        { values: 33..36, points: 'E.43(33) + Gi.3(32) , C.9(34-bad) + P.11(31-bad)
          E.42(35) + Gi.4(30), Rp.9(36) + F.8(29)' },
        { values: 29..32, points: 'F.8(29) + Rp.9(36), Gi.4(30) + E.42(35),
          P.11(31-bad) + C.9(34-bad), Gi.3(32) + E.43(33)' }, #mirror 33..36
        { values: 45..48, points: 'C.8(45) + F.3(20), E.36-bad(46) + Gi.2-bad(19),
          C.7(47) + F.4(18), E.41(48) + Gi.1(17)' },
        { values: 17..20, points: 'Gi.1(17) + E.41(48), F.4(18) + C.7(47),
          Gi.2-bad(19) + E.36-bad(46), F.3(20) + C.8(45)' }, # mirror 45..48
        { values: 25..28, points: 'C.4(25) + P.8(40), Rp.2(26) + F.2(39),
          C.3(27) + P.5(38), Rp.1(28) + F.1(37)' },
        { values: 37..40, points: 'F.1(37) + Rp.1(28), P.5(38) + C.3(27),
          F.2(39) + Rp.2(26), P.8(40) + C.4(25)' }, # mirror 25..28
        { values: 57..60, points: 'R.10(57) + R.3(8), TR.10(58) + V.66(7),
          MC.7(59) + R.7(6), TR.6(60) + V.67(5) ' },
        { values: 5..8, points: 'V.67(5) + TR.6(60), R.7(6) + MC.7(59),
          V.66(7) + TR.10(58), R.3(8) + R.10(57)' }, # mirror 57..60
        { values: 13..16, points: 'MC.5(13) + Ig.5(52), VB.43(14) + R.2(51),
          MC.3(15) + Ig.8(50), VB.44(16) + R.1(49)' },
        { values: 49..52, points: 'R.1(49) + VB.44(16), Ig.8(50) + MC.3(15),
          R.2(51) + VB.43(14), Ig.5(52) + MC.5(13) ' }, # mirror 13..16
        { values: 1..4, points: 'VB.41(1) + V.60(64), TR.2(2) + Ig.4(63),
          VB.40(3) + V.40(62), TR.1(4) + Ig.3(61)' },
        { values: 61..64, points: 'Ig.3(61) + TR.1(4), V.40(62) + VB.40(3),
          Ig.4(63) + TR.2(2), V.60(64) + VB.41(1) ' }, # mirror 1..4
        { values: 53..56, points: 'VB.38(53) + Ig.1(12), TR.4-bad(54) + V.64-bad(11),
          VB.34(55) + Ig.2(10), TR.3(56) + V.65(9)' },
        { values: 9..12, points: 'V.65(9) + TR.3(56), Ig.2(10) + VB.34(55),
         V.64-bad(11) + TR.4-bad(54), Ig.1(12) + VB.38(53)' }, # mirror 53..56
      ]
      when 6
      spleen =
      [
          { values: 21..24, points: 'Rp.1(21) + Gi.3(44), C.3(22) + E.36(43),
            Rp.2(23-bad) + Gi.4(42-bad), C.4(24) + E.41(41)' },
          { values: 41..44, points: 'E.41(41) + C.4(24), Gi.4(42-bad) + Rp.2(23-bad),
            E.36(43) + C.3(22), Gi.3(44) + Rp.1(21),' }, # mirror 21..24
          { values: 33..36, points: 'Rp.3(33) + E.43(32) , Ig.2(34-bad) + Gi.2(31-bad)
            Rp.5(35) + E.42(30), Ig.1(36) + Gi.1(29)' },
          { values: 29..32, points: 'Gi.1(29) + Ig.1(36), E.42(30) + Rp.5(35),
            Gi.2(31-bad) + Ig.2(34-bad), E.43(32) + Rp.3(33)' }, #mirror 33..36
          { values: 45..48, points: 'Ig.3(45) + P.8(20), C.9-bad(46) + E.44-bad(19),
            Ig.4(47) + P.5(18), Rp.9(48) + E.45(17)' },
          { values: 17..20, points: 'E.45(17) + Rp.9(48), P.5(18) + Ig.4(47),
            E.44-bad(19) + C.9-bad(46), P.8(20) + Ig.3(45)' }, # mirror 45..48
          { values: 25..28, points: 'Ig.5(25) + Gi.5(40), C.7(26) + P.9(39),
            Ig.8(27) + Gi.11(38), C.8(28) + P.10(37)' },
          { values: 37..40, points: 'P.10(37) + C.8(28), Gi.11(38) + Ig.8(27),
            P.9(39) + C.7(26), Gi.5(40) + Ig.5(25)' }, # mirror 25..28
          { values: 57..60, points: 'TR.3(57) + MC.5(8), VB.34(58) + R.2(7),
            TR.4(59) + MC.3(6), VB.38(60) + R.1(5) ' },
          { values: 5..8, points: 'R.1(5) + VB.38(60), MC.3(6) + TR.4(59),
            R.2(7) + VB.34(58), MC.5(8) + TR.3(57)' }, # mirror 57..60
          { values: 13..16, points: 'TR.6(13) + V.60(52), F.2(14) + MC.7(51),
            TR.10(15) + V.40(50), F.1(16) + MC.8(49)' },
          { values: 49..52, points: 'MC.8(49) + F.1(16), V.40(50) + TR.10(15),
            MC.7(51) + F.2(14), V.60(52) + TR.6(13) ' }, # mirror 13..16
          { values: 1..4, points: 'F.3(1) + R.10(64), VB.43(2) + V.64(63),
            F.4(3) + MC.9(62), VB.44(4) + V.65(61)' },
          { values: 61..64, points: 'V.65(61) + VB.44(4), MC.9(62) + F.4(3),
            V.64(63) + VB.43(2), R.10(64) + F.3(1) ' }, # mirror 1..4
          { values: 53..56, points: 'F.8(53) + V.67(12), VB.40-bad(54) + R.7-bad(11),
            P.11(55) + V.66(10), VB.41(56) + R.3(9)' },
          { values: 9..12, points: 'R.3(9) + VB.41(56), V.66(10) + P.11(55),
           R.7-bad(11) + VB.40-bad(54), V.67(12) + F.8(53)' }, # mirror 53..56
      ]
      when 7
      heart =
      [
        { values: 21..24, points: 'C.9(21) + E.44(44), Ig.5(22) + Rp.9(43),
          C.8(23-bad) + E.43(42-bad), Ig.4(24) + Rp.5(41)' },
        { values: 41..44, points: 'Rp.5(41) + Ig.4(24), E.43(42-bad) + C.8(23-bad),
          Rp.9(43) + Ig.5(22), E.44(44) + C.9(21),' }, # mirror 21..24
        { values: 33..36, points: 'C.7(33) + Rp.2(32) , V.67(34-bad) + E.45(31-bad)
          C.4(35) + Rp.3(30), Ig.8(36) + Gi.11(29)' },
        { values: 29..32, points: 'Gi.11(29) + Ig.8(36), Rp.3(30) + C.4(35),
          E.45(31-bad) + V.67(34-bad), Rp.2(32) + C.7(33)' }, #mirror 33..36
        { values: 45..48, points: 'V.66(45) + Gi.4(20), Ig.1-bad(46) + Rp.1-bad(19),
          V.65(47) + Gi.5(18), C.3(48) + E.36(17)' },
        { values: 17..20, points: 'E.36(17) + C.3(48), Gi.5(18) + V.65(47),
          Rp.1-bad(19) + Ig.1-bad(46), Gi.4(20) + V.66(45)' }, # mirror 45..48
        { values: 25..28, points: 'V.64(25) + E.42(40), Ig.3(26) + Gi.3(39),
          V.60(27) + E.41(38), Ig.2(28) + Gi.2(37)' },
        { values: 37..40, points: 'Gi.2(37) + Ig.2(28), E.41(38) + V.60(27),
          Gi.3(39) + Ig.3(26), E.42(40) + V.6(25)' }, # mirror 25..28
        { values: 57..60, points: 'TR.10(57) + TR.4(8), F.8(58) + MC.8(7),
          VB.41(59) + TR.6(6), F.4(60) + MC.9(5) ' },
        { values: 5..8, points: 'MC.9(5) + F.4(60), TR.6(6) + VB.41(59),
          MC.8(7) + F.8(58), TR.4(8) + TR.10(57)' }, # mirror 57..60
        { values: 13..16, points: 'VB.40(13) + R.7(52), P.10(14) + TR.3(51),
          VB.38(15) + R.10(50), P.11(16) + TR.2(49)' },
        { values: 49..52, points: 'TR.2(49) + P.11(16), R.10(50) + VB.38(15),
          TR.3(51) + P.10(14), R.7(52) + VB.40(13) ' }, # mirror 13..16
        { values: 1..4, points: 'P.9(1) + MC.3(64), F.1(2) + R.3(63),
         P.8(3) + TR.1(62), VB.34(4) + R.2(61)' },
        { values: 61..64, points: 'R.2(61) + VB.34(4), TR.1(62) + P.8(3),
          R.3(63) + F.1(2), MC.3(64) + P.9(1) ' }, # mirror 1..4
        { values: 53..56, points: 'P.5(53) + V.40(12), F.3-bad(54) + MC.5-bad(11),
          Gi.1(55) + R.1(10), F.2(56) + MC.7(9)' },
        { values: 9..12, points: 'MC.7(9) + F.2(56), R.1(10) + Gi.1(55),
         MC.5-bad(11) + F.3-bad(54), V.40(12) + P.5(53)' }, # mirror 53..56
      ]
    when 8
      small_intestine =
      [
        { values: 21..24, points: 'Ig.1(21) + Rp.1(44), V.64(22) + C.3(43),
          Ig.2(23-bad) + Rp.2(42-bad), V.65(24) + C.4(41)' },
        { values: 41..44, points: 'C.4(41) + V.65(24), Rp.2(42-bad) + Ig.2(23-bad),
          C.3(43) + V.64(22), Rp.1(44) + Ig.1(21),' }, # mirror 21..24
        { values: 33..36, points: 'Ig.3(33) + C.8(32) , V.40(34-bad) + E.36(31-bad)
          Ig.4(35) + C.7(30), V.60(36) + E.41(29)' },
        { values: 29..32, points: 'E.41(29) + V.60(36), C.7(30) + Ig.4(35),
         E.36(31-bad) + V.40(34-bad), C.8(32) + Ig.3(33)' }, #mirror 33..36
        { values: 45..48, points: 'R.1(45) + E.43(20), Ig.8-bad(46) + C.9-bad(19),
          R.2(47) + E.42(18), Ig.5(48) + Rp.9(17)' },
        { values: 17..20, points: 'Rp.9(17) + Ig.5(48), E.42(18) + R.2(47),
          C.9-bad(19) + Ig.8-bad(46), E.43(20) + R.1(45)' }, # mirror 45..48
        { values: 25..28, points: 'R.3(25) + Rp.3(40), V.66(26) + E.44(39),
          R.7(27) + Rp.5(38), V.67(28) + E.45(37)' },
        { values: 37..40, points: 'E.45(37) + V.67(28), Rp.5(38) + R.7(27),
          E.44(39) + V.66(26), Rp.3(40) + R.3(25)' }, # mirror 25..28
        { values: 57..60, points: 'VB.38(57) + VB.41(8), P.5(58) + TR.2(7),
          VB.34(59) + VB.40(6), P.8(60) + TR.1(5) ' },
        { values: 5..8, points: 'TR.1(5) + P.8(60), VB.40(6) + VB.34(59),
          TR.2(7) + P.5(58), VB.41(8) + VB.38(57)' }, # mirror 57..60
        { values: 13..16, points: 'F.3(13) + MC.5(52), Gi.2(14) + VB.43(51),
          F.4(15) + MC.3(50), Gi.1(16) + VB.44(49)' },
        { values: 49..52, points: 'VB.44(49) + Gi.1(16), MC.3(50) + F.4(15),
          VB.43(51) + Gi.2(14), MC.5(52) + F.3(13) ' }, # mirror 13..16
        { values: 1..4, points: 'Gi.3(1) + TR.6(64), P.11(2) + MC.7(63),
          Gi.4(3) + TR.10(62), F.8(4) + MC.8(61)' },
        { values: 61..64, points: 'MC.8(61) + F.8(4), TR.10(62) + Gi.4(3),
          MC.7(63) + P.11(2), TR.6(64) + Gi.3(1) ' }, # mirror 1..4
        { values: 53..56, points: 'Gi.5(53) + R.10(12), P.9-bad(54) + TR.4-bad(11),
          Gi.11(55) + MC.9(10), P.10(56) + TR.3(9)' },
        { values: 9..12, points: 'TR.3(9) + P.10(56), MC.9(10) + Gi.11(55),
         TR.4-bad(11) + P.9-bad(54), R.10(12) + Gi.5(53)' }, # mirror 53..56
      ]
    when 9
      bladder =
      [
        { values: 21..24, points: 'V.67(21) + C.8(44), R.7(22) + Ig.8(43),
          V.66(23-bad) + C.7(42-bad), R.3(24) + Ig.5(41)' },
        { values: 41..44, points: 'Ig.5(41) + R.3(24), C.7(42-bad) + V.66(23-bad),
          Ig.8(43) + R.7(22), C.8(44) + V.67(21),' }, # mirror 21..24
        { values: 33..36, points: 'V.65(33) + Ig.3(32) , MC.9(34-bad) + C.9(31-bad)
          V.64(35) + Ig.4(30), R.10(36) + Rp.9(29)' },
        { values: 29..32, points: 'Rp.9(29) + R.10(36), Ig.4(30) + V.64(35),
          C.9(31-bad) + MC.9(34-bad), Ig.3(32) + V.65(33)' }, #mirror 33..36
        { values: 45..48, points: 'MC.8(45) + Rp.3(20), V.40-bad(46) + Ig.2-bad(19),
          MC.7(47) + Rp.5(18), V.60(48) + Ig.1(17)' },
        { values: 17..20, points: 'Ig.1(17) + V.60(48), Rp.5(18) + MC.7(47),
          Ig.2-bad(19) + V.40-bad(46), Rp.3(20) + MC.8(45)' }, # mirror 45..48
        { values: 25..28, points: 'MC.5(25) + C.4(40), R.2(26) + Rp.2(39),
          MC.3(27) + C.3(38), R.1(28) + Rp.1(37)' },
        { values: 37..40, points: 'Rp.1(37) + R.1(28), C.3(38) + MC.3(27),
          Rp.2(39) + R.2(26), C.4(40) + MC.5(25)' }, # mirror 25..28
        { values: 57..60, points: 'F.8(57) + F.3(8), Gi.11(58) + VB.43(7),
          P.9(59) + F.4(6), Gi.5(60) + VB.44(5) ' },
        { values: 5..8, points: 'VB.44(5) + Gi.5(60), F.4(6) + P.9(59),
          VB.43(7) + Gi.11(58), F.3(8) + F.8(57)' }, # mirror 57..60
        { values: 13..16, points: 'P.8(13) + TR.6(52), E.44(14) + F.2(51),
          P.5(15) + TR.10(50), E.45(16) + F.1(49)' },
        { values: 49..52, points: 'F.1(49) + E.45(16), TR.10(50) + P.5(15),
          F.2(51) + E.44(14), TR.6(52) + P.8(13) ' }, # mirror 13..16
        { values: 1..4, points: 'E.43(1) + VB.38(64), Gi.2(2) + TR.4(63),
          E.43(3) + VB.34(62), Gi.1(4) + TR.3(61)' },
        { values: 61..64, points: 'TR.3(61) + Gi.1(4), VB.34(62) + E.43(3),
          TR.4(63) + Gi.2(2), VB.38(64) + E.43(1) ' }, # mirror 1..4
        { values: 53..56, points: 'E.41(53) + TR.1(12), Gi.4-bad(54) + VB.40-bad(11),
          E.36(55) + TR.2(10), Gi.3(56) + VB.41(9)' },
        { values: 9..12, points: 'VB.41(9) + Gi.3(56), TR.2(10) + E.36(55),
         VB.40-bad(11) + Gi.4-bad(54), TR.1(12) + E.41(53)' }, # mirror 53..56
      ]
    when 10
      kidney =
      [
          { values: 21..24, points: 'R.1(21) + Ig.3(44), MC.3(22) + V.40(43),
            R.2(23-bad) + Ig.4(42-bad), MC.5(24) + V.60(41)' },
          { values: 41..44, points: 'V.60(41) + MC.5(24), Ig.4(42-bad) + R.2(23-bad),
            V.40(43) + MC.3(22), Ig.3(44) + R.1(21),' }, # mirror 21..24
          { values: 33..36, points: 'R.3(33) + V.65(32) , TR.2(34-bad) + Ig.2(31-bad)
            R.7(35) + V.64(30), TR.1(36) + Ig.1(29)' },
          { values: 29..32, points: 'Ig.1(29) + TR.1(36), V.64(30) + R.7(35),
            Ig.2(31-bad) + TR.2(34-bad), V.65(32) + R.3(33)' }, #mirror 33..36
          { values: 45..48, points: 'TR.3(45) + C.4(20), MC.9-bad(46) + V.66-bad(19),
            TR.4(47) + C.3(18), R.10(48) + V.67(17)' },
          { values: 17..20, points: 'V.67(17) + R.10(48), C.3(18) + TR.4(47),
            V.66-bad(19) + MC.9-bad(46), C.4(20) + TR.3(45)' }, # mirror 45..48
          { values: 25..28, points: 'TR.6(25) + Ig.5(40), MC.7(26) + C.7(39),
            TR.10(27) + Ig.8(38), MC.8(28) + C.8(37)' },
          { values: 37..40, points: 'C.8(37) + MC.8(28), Ig.8(38) + TR.10(27),
            C.7(39) + MC.7(26), Ig.5(40) + TR.6(25)' }, # mirror 25..28
          { values: 57..60, points: 'Gi.3(57) + P.8(8), E.36(58) + F.2(7),
            Gi.4(59) + P.5(6), E.41(60) + F.1(5) ' },
          { values: 5..8, points: 'F.1(5) + E.41(60), P.5(6) + Gi.4(59),
            F.2(7) + E.36(58), P.8(8) + Gi.3(57)' }, # mirror 57..60
          { values: 13..16, points: 'Gi.5(13) + VB.38(52), Rp.2(14) + P.9(51),
            Gi.11(15) + VB.34(50), Rp.1(16) + P.10(49)' },
          { values: 49..52, points: 'P.10(49) + Rp.1(16), VB.34(50) + Gi.11(15),
            P.9(51) + Rp.2(14), VB.38(52) + Gi.5(13) ' }, # mirror 13..16
          { values: 1..4, points: 'Rp.3(1) + F.8(64), E.44(2) + VB.40(63),
            Rp.5(3) + P.11(62), E.45(4) + VB.41(61)' },
          { values: 61..64, points: 'VB.41(61) + E.45(4), P.11(62) + Rp.5(3),
            VB.40(63) + E.44(2), F.8(64) + Rp.3(1) ' }, # mirror 1..4
          { values: 53..56, points: 'Rp.9(53) + VB.44(12), E.42-bad(54) + F.4-bad(11),
            C.9(55) + VB.43(10), E.43(56) + F.3(9)' },
          { values: 9..12, points: 'F.3(9) + E.43(56), VB.43(10) + C.9(55),
          F.4-bad(11) + E.42-bad(54), VB.44(12) + Rp.9(53)' }, # mirror 53..56
      ]
    when 11
      pericardium =
      [
        { values: 21..24, points: 'MC.9(21) + V.66(44), TR.6(22) + R.10(43),
          MC.8(23-bad) + V.65(42-bad), TR.4(24) + R.7(41)' },
        { values: 41..44, points: 'R.7(41) + TR.4(24), V.65(42-bad) + MC.8(23-bad),
          R.10(43) + TR.6(22), V.66(44) + MC.9(21),' }, # mirror 21..24
        { values: 33..36, points: 'MC.7(33) + R.2(32) , VB.44(34-bad) + V.67(31-bad)
          MC.5(35) + R.3(30), TR.10(36) + Ig.8(29)' },
        { values: 29..32, points: 'Ig.8(29) + TR.10(36), R.3(30) + MC.5(35),
          V.67(31-bad) + VB.44(34-bad), R.2(32) + MC.7(33)' }, #mirror 33..36
        { values: 45..48, points: 'VB.43(45) + Ig.4(20), TR.1-bad(46) + R.1-bad(19),
          VB.41(47) + Ig.5(18), MC.3(48) + V.40(17)' },
        { values: 17..20, points: 'V.40(17) + MC.3(48), Ig.5(18) + VB.41(47),
          R.1-bad(19) + TR.1-bad(46), Ig.4(20) + VB.43(45)' }, # mirror 45..48
        { values: 25..28, points: 'VB.40(25) + V.64(40), TR.3(26) + Ig.3(39),
          VB.38(27) + V.60(38), TR.2(28) + Ig.2(37)' },
        { values: 37..40, points: 'Ig.2(37) + TR.2(28), V.60(38) + VB.38(27),
          Ig.3(39) + TR.3(26), V.64(40) + VB.40(25)' }, # mirror 25..28
        { values: 57..60, points: 'Gi.11(57) + Gi.4(8), Rp.9(58) + P.10(7),
          E.43(59) + Gi.5(6), Rp.5(60) + P.11(5) ' },
        { values: 5..8, points: 'P.11(5) + Rp.5(60), Gi.5(6) + E.43(59),
          P.10(7) + Rp.9(58), Gi.4(8) + Gi.11(57)' }, # mirror 57..60
        { values: 13..16, points: 'E.42(13) + F.4(52), C.8(14) + Gi.3(51),
          E.41(15) + F.8(50), C.9(16) + Gi.2(49)' },
        { values: 49..52, points: 'Gi.2(49) + C.9(16), F.8(50) + E.41(15),
          Gi.3(51) + C.8(14), F.4(52) + E.42(13) ' }, # mirror 13..16
        { values: 1..4, points: 'C.7(1) + P.5(64), Rp.1(2) + F.3(63),
          C.4(3) + Gi.1(62), E.36(4) + F.2(61)' },
        { values: 61..64, points: 'F.2(61) + E.36(4), Gi.1(62) + C.4(3),
          F.3(63) + Rp.1(2), P.5(64) + C.7(1) ' }, # mirror 1..4
        { values: 53..56, points: 'C.3(53) + VB.34(12), Rp.3-bad(54) + P.8-bad(11),
          Ig.1(55) + F.1(10), Rp.2(56) + P.9(9)' },
        { values: 9..12, points: 'P.9(9) + Rp.2(56), F.1(10) + Ig.1(55),
         P.8-bad(11) + Rp.3-bad(54), VB.34(12) + C.3(53)' }, # mirror 53..56
      ]
      when 12
      trois_reshaffeurs =
      [
          { values: 21..24, points: 'TR.1(21) + R.1(44), VB.40(22) + MC.3(43),
            TR.2(23-bad) + R.2(42-bad), VB.41(24) + MC.5(41)' },
          { values: 41..44, points: 'MC.5(41) + VB.41(24), R.2(42-bad) + TR.2(23-bad),
            MC.3(43) + VB.40(22), R.1(44) + TR.1(21),' }, # mirror 21..24
          { values: 33..36, points: 'TR.3(33) + MC.8(32) , VB.34(34-bad) + V.40(31-bad)
            TR.4(35) + MC.7(30), VB.38(36) + V.60(29)' },
          { values: 29..32, points: 'V.60(29) + VB.38(36), MC.7(30) + TR.4(35),
            V.40(31-bad) + VB.34(34-bad), MC.8(32) + TR.3(33)' }, #mirror 33..36
          { values: 45..48, points: 'F.1(45) + V.65(20), TR.10-bad(46) + MC.9-bad(19),
            F.2(47) + V.64(18), TR.6(48) + R.10(17)' },
          { values: 17..20, points: 'R.10(17) + TR.6(48), V.64(18) + F.2(47),
            MC.9-bad(19) + TR.10-bad(46), V.65(20) + F.1(45)' }, # mirror 45..48
          { values: 25..28, points: 'F.3(25) + R.3(40), VB.43(26) + V.66(39),
            F.4(27) + R.7(38), VB.44(28) + V.67(37)' },
          { values: 37..40, points: 'V.67(37) + VB.44(28), R.7(38) + F.4(27),
            V.66(39) + VB.43(26), R.3(40) + F.3(25)' }, # mirror 25..28
          { values: 57..60, points: 'E.41(57) + E.43(8), C.3(58) + Gi.2(7),
            E.36(59) + E.42(6), C.4(60) + Gi.1(5) ' },
          { values: 5..8, points: 'Gi.1(5) + C.4(60), E.42(6) + E.36(59),
            Gi.2(7) + C.3(58), E.43(8) + E.41(57)' }, # mirror 57..60
          { values: 13..16, points: 'Rp.3(13) + P.8(52), Ig.2(14) + E.44(51),
            Rp.5(15) + P.5(50), Ig.1(16) + E.45(49)' },
          { values: 49..52, points: 'E.45(49) + Ig.1(16), P.5(50) + Rp.5(15),
            E.44(51) + Ig.2(14), P.8(52) + Rp.3(13) ' }, # mirror 13..16
          { values: 1..4, points: 'Ig.3(1) + Gi.5(64), C.9(2) + P.9(63),
            Ig.4(3) + Gi.11(62), Rp.9(4) + P.10(61)' },
          { values: 61..64, points: 'P.10(61) + Rp.9(4), Gi.11(62) + Ig.4(3),
            P.9(63) + C.9(2), Gi.5(64) + Ig.3(1) ' }, # mirror 1..4
          { values: 53..56, points: 'Ig.5(53) + F.8(12), C.7-bad(54) + Gi.4-bad(11),
            Ig.8(55) + P.11(10), C.8(56) + Gi.3(9)' },
          { values: 9..12, points: 'Gi.3(9) + C.8(56), P.11(10) + Ig.8(55),
           Gi.4-bad(11) + C.7-bad(54), F.8(12) + Ig.5(53)' }, # mirror 53..56
      ]
    end
  end

  def lo_shu_points(matrix, first_point_lo_shu)
    matrix.find do |point|
      point[:values].include?(first_point_lo_shu)
    end
  end

end