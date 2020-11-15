class LunarPalace
   attr_reader :year, :month, :day

  def initialize(year:, month:, day:)
    @year = year
    @month = month
    @day = day
  end

  def lunar_palaces_year_num
    case year
      when 1920, 1942, 1987, 2009, 2032  then 1
      when 1943, 1965, 1988, 2010 then 2
      when 1921, 1944, 1966, 2011, 2033 then 3
      when 1922, 1967, 1989, 2012, 2034 then 4
      when 1923, 1945, 1968, 1990, 2035 then 5
      when 1924, 1946, 1991, 2013, 2036 then 6
      when 1947, 1969, 1992, 2014 then 7
      when 1925, 1948, 1970, 2015, 2037 then 8
      when 1926, 1971, 1993, 2016, 2038 then 9
      when 1927, 1949, 1972, 1994, 2039 then 10
      when 1928, 1950, 1995, 2017, 2040 then 11
      when 1951, 1973, 1996, 2018 then 12
      when 1929, 1952, 1974, 2019, 2041 then 13
      when 1930, 1975, 1997, 2020, 2042 then 14
      when 1931, 1953, 1976, 1998, 2043 then 15
      when 1932, 1954, 1999, 2021, 204 then 16
      when 1955, 1977, 2000, 2022 then 17
      when 1933, 1956, 1978, 2023, 2045 then 18
      when 1934, 1979, 2001, 2024, 2046 then 19
      when 1935, 1957, 1980, 2002, 2047 then 20
      when 1936, 1958, 2003, 2025, 2048 then 21
      when 1959, 1981, 2004, 2026 then 22
      when 1937, 1960, 1982, 2027, 2049 then 23
      when 1938, 1983, 2005, 2028, 2050 then 24
      when 1939, 1961, 1984, 2006, 2051 then 25
      when 1940, 1962, 2007, 2029, 2052 then 26
      when 1963, 1985, 2008, 2030 then 27
      when 1941, 1964, 1986, 2031, 2053 then 28
        else 0
    end
  end

  def lunar_palaces_month_num
    case month
      when 1 then 27
      when 2 then 2
      when 3 then 2
      when 4 then 5
      when 5 then 7
      when 6 then 10
      when 7 then 12
      when 8 then 15
      when 9 then 18
      when 10 then 20
      when 11 then 23
      when 12 then 25
    end
  end

  def lunar_palaces_leap_correction
    if  year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)
      1
    else
      0
    end
  end

  def lunar_palace
    # binding.pry
    sum = day + month + year + lunar_palaces_leap_correction
    if sum > 28
      sum%28
    else
      sum
    end
  end

  def lunar_palace_opposite
    lunar_palace_result = lunar_palace

    if lunar_palace_result.between?(15, 28)
      lunar_palace_result - 14
    elsif lunar_palace_result == 0
      14
    elsif lunar_palace_result.between?(1, 14)
      lunar_palace_result + 14
    else
      raise "Ошибка метода lunar_palace_opposite"
    end
  end
  # выводим точки по секторам, мужские и женские
  #
  def points_of_lunar_palaces
    result = []
    case lunar_palace_opposite
      when 1
        result << { men: Point.where(name: 'F.1'), woman: [Point.find_by(name: 'Vb.41')] }
      when 2
        result << { men: [ Point.find_by(name: 'F.4') ], woman: [ Point.find_by(name: 'Vb.44') ]  }
      when 3
        result << { men: [ Point.find_by(name: 'F.3') ], woman: [ Point.find_by(name: 'Vb.34') ]  }
      when 4
        result << { men: [ Point.find_by(name: 'F.3'), Point.find_by(name: 'Vb.37') ],
         woman: [ Point.find_by(name: 'Vb.37'), Point.find_by(name: 'F.3') ]  }
      when 5
        result << { men: Point.where(name: ['F.5', 'Vb.40']),
         woman: [ Point.find_by(name: 'F.5'), Point.find_by(name: 'Vb.40') ]  }
      when 6
        result << { men: [ Point.find_by(name: 'F.2') ], woman: [ Point.find_by(name: 'Vb.38') ]  }
      when 7
        result << { men: [ Point.find_by(name: 'F.8') ], woman: [ Point.find_by(name: 'Vb.43') ]  }
      when 8
        result << { men: [ Point.find_by(name: 'R.1') ], woman: [ Point.find_by(name: 'V.65') ]  }
      when 9
        result << { men: [ Point.find_by(name: 'R.7') ], woman: [ Point.find_by(name: 'V.67') ]  }
      when 10
        result << { men: [ Point.find_by(name: 'R.3') ], woman: [ Point.find_by(name: 'V.40') ]  }
      when 11
        result << { men: [ Point.find_by(name: 'R.3'), Point.find_by(name: 'V.58') ],
          woman: [ Point.find_by(name: 'R.3'), Point.find_by(name: 'V.58') ]  }
      when 12
        result << { men: [ Point.find_by(name: 'R.4'), Point.find_by(name: 'V.64') ],
          woman: [ Point.find_by(name: 'R.4'), Point.find_by(name: 'V.64') ]  }
      when 13
        result << { men: [ Point.find_by(name: 'R.2') ], woman: [ Point.find_by(name: 'V.60') ]  }
      when 14
        result << { men: [ Point.find_by(name: 'R.10') ], woman: [ Point.find_by(name: 'V.66') ]  }
      when 15
        result << { men: [ Point.find_by(name: 'P.11') ], woman: [ Point.find_by(name: 'Gi.3') ]  }
      when 16
        result << { men: [ Point.find_by(name: 'P.8') ], woman: [ Point.find_by(name: 'Gi.1') ]  }
      when 17
        result << { men: [ Point.find_by(name: 'P.9') ], woman: [ Point.find_by(name: 'Gi.11') ]  }
      when 18
        result << { men: [ Point.find_by(name: 'Gi.6'), Point.find_by(name: 'P.9') ],
          woman: [ Point.find_by(name: 'Gi.6'), Point.find_by(name: 'Gi.11') ]  }
      when 19
        result << { men: [ Point.find_by(name: 'Gi.4'), Point.find_by(name: 'P.7') ],
          woman: [ Point.find_by(name: 'P.7'), Point.find_by(name: 'Gi.4') ]  }
      when 20
        result << { men: [ Point.find_by(name: 'P.10') ], woman: [ Point.find_by(name: 'Gi.5') ]  }
      when 21
        result << { men: [ Point.find_by(name: 'P.5') ], woman: [ Point.find_by(name: 'Gi.2') ]  }
      when 22
        result << { men: [ Point.find_by(name: 'C.9'), Point.find_by(name: 'Mc.9') ],
          woman: [ Point.find_by(name: 'Ig.3') ]  }
      when 23
        result << { men: [ Point.find_by(name: 'C.4'), Point.find_by(name: 'Mc.5') ],
          woman: [ Point.find_by(name: 'Ig.1') ]  }
      when 24
        result << { men: [ Point.find_by(name: 'C.7'), Point.find_by(name: 'Mc.7') ],
          woman: [ Point.find_by(name: 'Ig.8') ]  }
      when 25
        result << { men: [ Point.find_by(name: 'Ig.7'), Point.find_by(name: 'C.7'),
          Point.find_by(name: 'Mc.7') ],
          woman: [ Point.find_by(name: 'Ig.7'), Point.find_by(name: 'C.7'),
          Point.find_by(name: 'Mc.7') ]  }
      when 26
        result << { men: [ Point.find_by(name: 'Ig.4'), Point.find_by(name: 'C.5'),
          Point.find_by(name: 'Mc.6') ],
          woman: [ Point.find_by(name: 'C.5'), Point.find_by(name: 'Ig.4') ]  }
      when 27
        result << { men: [ Point.find_by(name: 'C.8'), Point.find_by(name: 'Mc.8') ],
          woman: [ Point.find_by(name: 'Ig.5') ]  }
      when 28
        result << { men: [ Point.find_by(name: 'C.3'), Point.find_by(name: 'Mc.3') ],
          woman: [ Point.find_by(name: 'Ig.2') ]  }
    end
    return result
  end

end