#метод сл. простр. баланса, вариант с 60-летним циклом

@doctor_current_date = DateTime.current
  # приходит из params, в реальности будет Date.civil(params[:...])
@patient_birthdate = DateTime.new(1977, 9, 18)

CITIES = [
  {city: 'Magnitogorsk', lng: 59.6},
  {city: 'Moscow', lng: 37.64},
  {city: 'Novosibirsk', lng: 82.9}
]

doctor_city = CITIES[0]
patient_city = CITIES[0]

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

@doctor_current_date = DateTime.current
  # приходит из params, в реальности будет Date.civil(params[:...])
@patient_birthdate = DateTime.new(1978, 7, 2, 12, 30)

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

number_of_day = number_of_day_calculation(doctor_city, @doctor_current_date)

#вычисляем день по Насонову %60
def patient_birthdate_day_number(num_day)
  (num_day - 14)%60
end

p patient_birthdate_day_number(number_of_day)

# НОМЕР ГОДА по циклу-60
def year_number_60th_calculation(birth)
    y = birth.year % 60 - 3
    if y < 1
      y + 60
    elsif y > 60
      y - 60
      else y
    end
end
 year_num_patient = year_number_60th_calculation(@patient_birthdate)

# момент рождения пацика (по Солнцу)
def moment_of_birth(time, city)
  moment_of_birth = (time + (city[:lng]*4).minutes + eot_patient(time).seconds).hour
end
moment_of_birth(@patient_birthdate, patient_city)

# стража на момент рождения пацика.

def guard(time, city)
  case moment_of_birth(time, city)
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

# получаем Номер Стражи Пациента:
guard_patient = guard(@patient_birthdate, patient_city)
guard_doctor = guard(@doctor_current_date, doctor_city)


def ranges
[

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

]
end

def patient_month_calculation # month's number from Hongcong observatotie's table
   ranges.find do |range|
    range[:dates].include?(@patient_birthdate.to_date)
  end
end


# получаем Число Месяца Пациента:
 month_patient_lo_shu = patient_month_calculation[:value]

 day_patient_lo_shu = patient_birthdate_day_number(number_of_day)

p "EOT = " + eot.to_s
p "EOT пацика = " + eot_patient(@patient_birthdate).to_s

p "Номер года: " + year_num_patient.to_s
p "Номер МЕСЯЦА: " + month_patient_lo_shu.to_s
p "НОМЕР ДНЯ: " + day_patient_lo_shu.to_s
p "НОМЕР СТРАЖИ пацика: " + guard_patient.to_s
p "НОМЕР СТРАЖИ доктора: " + guard_doctor.to_s


def first_point_lo_shu_number(year, month, day_p, day_d )
  s = (year + month + day_p + day_d)%64
  if s == 0
    s = 64
  else
    s
  end
end
first_point_lo_shu = first_point_lo_shu_number(year_num_patient, month_patient_lo_shu,
 day_patient_lo_shu, guard_doctor)

p "Номер ячейки 1-ой точки: "  + first_point_lo_shu.to_s


gall_bladder = {
  1=>'VB.44',   2=>'VB.43', 3=>'VB.41',  4=>'VB.40',     5=>'Vb.38(bad)', 6=>'VB.34',  7=>'F.1',   8=>'F.2',
  9=>'F.3',     10=>'F.4',  11=>'F.8',   12=>'P.11 bad', 13=>'P.10',      14=>'P.9',   15=>'P.8',  16=>'P.5',
  17=>'Gi.1',   18=>'Gi.2', 19=>'Gi.3',  20=>'Gi.4',     21=>'Gi.5',      22=>'Gi.11', 23=>'E.45', 24=>'E.44',
  25=>'E.43',   26=>'E.42', 27=>'E.41',  28=>'E.36',     29=>'Rp.1',      30=>'Rp.2',  31=>'Rp.3', 32=>'Rp.5',
  33=>'Rp.9',   34=>'C.7',  35=>'C.4',   36=>'C.3',      37=>'Ig.1',      38=>'Ig.2',  39=>'Ig.3', 40=>'Ig.4',
  41=>'Ig.5',   42=>'Ig.8', 43=>'V.67',  44=>'V.66',     45=>'V.65',      46=>'V.64',  47=>'V.60', 48=>'V.40',
  49=>'R.1',    50=>'R.2',  51=>'R.3',   52=>'R.7',      53=>'R.10',      54=>'MC.9',  55=>'MC.8', 56=>'MC.7',
  57=>'MC.5',   58=>'MC.3', 59=>'TR.1',  60=>'TR.2',     61=>'TR.3',      62=>'TR.4',  63=>'TR.6', 64=>'TR.10'
}







# матрица для продолжения таблицы ranges
  # { value: , dates: DateTime.new(1978, )..DateTime.new(1978, ) },
