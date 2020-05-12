class PointsController < ApplicationController

   def linguibafa
      @doctor_current_date = DateTime.civil(params[:user]["date(1i)"].to_i,
        params[:user]["date(2i)"].to_i,params[:user]["date(3i)"].to_i,
        params[:user]["date(4i)"].to_i,params[:user]["date(5i)"].to_i)
      @sun_time = sun_time(CITIES[0], @doctor_current_date)
      @doctor_city = CITIES[0]
      @trunc_day = trunc_day_calculation(CITIES[0], @doctor_current_date)
      @opened_points_linguibafa = opened_point_linguibafa(CITIES[0], @doctor_current_date)
      @sum_of_numbers_linguibafa = sum_of_numbers_linguibafa(CITIES[0], @doctor_current_date)
      render "doctors/linguibafa"
   end

    def infusion
      @doctor_current_date = DateTime.civil(params[:user]["date(1i)"].to_i,
        params[:user]["date(2i)"].to_i,params[:user]["date(3i)"].to_i,
        params[:user]["date(4i)"].to_i,params[:user]["date(5i)"].to_i)
      @sun_time = sun_time(CITIES[0], @doctor_current_date)
      @doctor_city = CITIES[0]
      @trunc_day = trunc_day_calculation(CITIES[0], @doctor_current_date)
      @guard = guard(CITIES[0], @doctor_current_date)
      @points_infusion = points_infusion
      @opened_points_infusion = opened_points_infusion(@trunc_day, @guard, @points_infusion)
      render "doctors/infusion"
      # There is SUN TIME in the table!
    end

    def naganfa
      @doctor_current_date = DateTime.civil(params[:user]["date(1i)"].to_i,
        params[:user]["date(2i)"].to_i,params[:user]["date(3i)"].to_i,
        params[:user]["date(4i)"].to_i,params[:user]["date(5i)"].to_i)
      @sun_time = sun_time(CITIES[0], @doctor_current_date)
      @doctor_city = CITIES[0]
      @trunc_day = trunc_day_calculation(CITIES[0], @doctor_current_date)
      @guard = guard(CITIES[0], @doctor_current_date)
      @mark = time_mark(@doctor_current_date)
      @points_naganfa = points_naganfa
      @opened_points_naganfa = opened_points_naganfa(@trunc_day, @mark, @points_naganfa, @doctor_current_date)
      render "doctors/naganfa"
      # There is TIME.now in the table!
    end

    def eot
      pi = (Math::PI) # pi
      delta = (DateTime.now.getutc.yday - 1) # (Текущий день года - 1)

      yy = DateTime.now.getutc.year
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

      a = DateTime.now.getutc.to_a; delta = delta + a[2].to_f / 24 + a[1].to_f / 60 / 24 # Поправка на дробную часть дня

      lambda = 23.4406 * pi / 180; # Earth's inclination in radians
      omega = 2 * pi / 365.2564 # angular velocity of annual revolution (radians/day)
      alpha = omega * ((delta + 10) % 365) # angle in (mean) circular orbit, solar year starts 21. Dec
      beta = alpha + 0.03340560188317 * Math.sin(omega * ((delta - np) % 365)) # angle in elliptical orbit, from perigee  (radians)
      gamma = (alpha - Math.atan(Math.tan(beta) / Math.cos(lambda))) / pi # angular correction

      eot = (43200 * (gamma - gamma.round)) # equation of time in seconds
    end

    CITIES = [
      {city: 'Magnitogorsk', lng: 59.6},
      {city: 'Moscow', lng: 37.64},
      {city: 'Novosibirsk', lng: 82.9}
    ]

    doctor_city = CITIES[0]

    def sun_time(city, date)
      DateTime.current.utc  + (city[:lng]*4).minutes + eot.seconds
    end

    def number_of_day_calculation(city, date)
      if date < 3
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

    def guard(city, date) # таблица Стражи Часа
      case sun_time(city, date).hour
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
      when 1 then 'V.62 Shen-mai'
      when 2, 5 then 'R.6 Zhao-hai'
      when 3 then 'TR.5 Wai-guan'
      when 4 then 'GB.41 Zu-lin-qi'
      when 6 then 'RP.4 Gong-sun'
      when 7 then 'IG.3 Hou-xi'
      when 8 then 'MC.5 Nei-guan'
      when 9 then 'P.7 Lie-que'
      when 0
        if trunc_day_calculation(city, date).even?
          'RP.4 Gong-sun'
        else
          'P.7 Lie-que'
        end
      end
    end

    # END OF LINGUIBAFA METHOD


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
        'MC.9 Zhong-chong',
        'MC.8 Lao-gong',
        'MC.7 Da-ling',
        'MC.5 Jian-shi',
        'MC.3 Qu-ze'
      ], # MC  PERICARD

      [
        '12th GUARD SAN JIAO',
        'TR.1 Guan-chong',
        'TR.2 Ye-men',
        'TR.3 Zhong-zhu' + ' and ' +  'TR.4 Yang-chi',
        'TR.6 Zhi-gou',
        'TR.10 Tian-jing'
      ] # SAN JIAO
      ]
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
end
