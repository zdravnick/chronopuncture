class Trunc < ApplicationRecord

  belongs_to :year_meridian, class_name: 'Meridian'

  # def self.trunc_year_wu_yun_definition(date)
  #   if
  #     [1924, 1934, 1944, 1954, 1964, 1974, 1984, 1994, 2004, 2014, 2024, 2034, 2044, 2054,
  #       2064, 2074, 2084, 2094].include?(date.year)
  #     Trunc.all.find_by(serial_number: 1)
  #     elsif [1925, 1935, 1945, 1955, 1965, 1975, 1985, 1995,
  #      2005, 2015, 2025, 2035, 2045, 2055, 2065, 2075, 2085, 2095].include?(date.year)
  #      Trunc.all.find_by(serial_number: 2)
  #     elsif [1926, 1936, 1946, 1956, 1966, 1976,
  #      1986, 1996, 2006, 2016, 2026, 2036, 2046, 2056, 2066, 2076, 2086, 2096].include?(date.year)
  #      Trunc.all.find_by(serial_number: 3)
  #     elsif [1927, 1937, 1947, 1957, 1967, 1977,
  #      1987, 1997, 2007, 2017, 2027, 2037, 2047, 2057, 2067, 2077, 2087, 2097].include?(date.year)
  #      Trunc.all.find_by(serial_number: 4)
  #     elsif [1928, 1938, 1948, 1958, 1968, 1978,
  #      1988, 1998, 2008, 2018, 2028, 2038, 2048, 2058, 2068, 2078, 2088, 2098].include?(date.year)
  #      Trunc.all.find_by(serial_number: 5)
  #     elsif [1929, 1939, 1949, 1959, 1969, 1979,
  #      1989, 1999, 2009, 2019, 2029, 2039, 2049, 2059, 2069, 2079, 2089, 2099].include?(date.year)
  #      Trunc.all.find_by(serial_number: 6)
  #     elsif [1920, 1930, 1940, 1950, 1960, 1970,
  #      1980, 1990, 2000, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100].include?(date.year)
  #      Trunc.all.find_by(serial_number: 7)
  #     elsif [1921, 1931, 1941, 1951, 1961, 1971,
  #      1981, 1991, 2001, 2011, 2021, 2031, 2041, 2051, 2061, 2071, 2081, 2091, 2101].include?(date.year)
  #      Trunc.all.find_by(serial_number: 8)
  #     elsif [1922, 1932, 1942, 1952, 1962, 1972,
  #      1982, 1992, 2002, 2012, 2022, 2032, 2042, 2052, 2062, 2072, 2082, 2092, 2102].include?(date.year)
  #      Trunc.all.find_by(serial_number: 9)
  #     elsif [1923, 1933, 1943, 1953, 1963, 1973,
  #     1983, 1993, 2003, 2013, 2023, 2033, 2043, 2053, 2063, 2073, 2083, 2093, 2103].include?(date.year)
  #     Trunc.all.find_by(serial_number: 10)
  #   end
  # end

  def self.trunc_year_wu_yun_definition(date)
    ranges = [
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1941, 1, 27)..DateTime.new(1942, 2, 14) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1942, 2, 15)..DateTime.new(1943, 2, 4) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1943, 2, 5)..DateTime.new(1944, 1, 24) },
      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1944, 1, 25)..DateTime.new(1945, 2, 12) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1945, 2, 13)..DateTime.new(1946, 2, 1) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1946, 2, 2)..DateTime.new(1947, 1, 20) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1947, 1, 21)..DateTime.new(1948, 2, 9) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1948, 2, 10)..DateTime.new(1949, 1, 28) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1949, 1, 29)..DateTime.new(1950, 2, 16) },
      { value: Trunc.find_by(serial_number: 7), dates: DateTime.new(1950, 2, 17)..DateTime.new(1951, 2, 5) },
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1951, 2, 6)..DateTime.new(1952, 1, 26) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1952, 1, 27)..DateTime.new(1953, 2, 13) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1953, 2, 14)..DateTime.new(1954, 2, 2) },

      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1954, 2, 3)..DateTime.new(1955, 1, 23) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1955, 1, 24)..DateTime.new(1956, 2, 11) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1956, 2, 12)..DateTime.new(1957, 1, 30) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1957, 1, 31)..DateTime.new(1958, 2, 17) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1958, 2, 18)..DateTime.new(1959, 2, 7) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1959, 2, 8)..DateTime.new(1960, 1, 27) },
      { value: Trunc.find_by(serial_number: 7), dates: DateTime.new(1960, 1, 28)..DateTime.new(1961, 2, 14) },
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1961, 2, 15)..DateTime.new(1962, 2, 4) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1962, 2, 5)..DateTime.new(1963, 1, 24) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1963, 1, 25)..DateTime.new(1964, 2, 12) },

      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1964, 2, 13)..DateTime.new(1965, 2, 1) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1965, 2, 2)..DateTime.new(1966, 1, 20) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1966, 1, 21)..DateTime.new(1967, 2, 8) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1967, 2, 9)..DateTime.new(1968, 1, 29) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1968, 1, 30)..DateTime.new(1969, 2, 16) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1969, 2, 17)..DateTime.new(1970, 2, 5) },
      { value: Trunc.find_by(serial_number: 7), dates: DateTime.new(1970, 2, 6)..DateTime.new(1971, 1, 26) },
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1971, 1, 27)..DateTime.new(1972, 2, 14) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1972, 2, 15)..DateTime.new(1973, 2, 2) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1973, 2, 3)..DateTime.new(1974, 1, 22) },

      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1974, 1, 23)..DateTime.new(1975, 2, 10) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1975, 2, 11)..DateTime.new(1976, 1, 30) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1976, 1, 31)..DateTime.new(1977, 2, 17) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1977, 2, 18)..DateTime.new(1978, 2, 6) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1978, 2, 7)..DateTime.new(1979, 1, 27) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1979, 1, 28)..DateTime.new(1980, 2, 15) },
      { value: Trunc.find_by(serial_number: 7), dates: DateTime.new(1980, 2, 16)..DateTime.new(1981, 2, 4) },
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1981, 2, 5)..DateTime.new(1982, 1, 24) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1982, 1, 25)..DateTime.new(1983, 2, 12) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1983, 2, 13)..DateTime.new(1984, 2, 1) },

      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1984, 2, 2)..DateTime.new(1985, 2, 19) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1985, 2, 20)..DateTime.new(1986, 2, 8) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1986, 2, 9)..DateTime.new(1987, 1, 28) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1987, 1, 29)..DateTime.new(1988, 2, 16) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1988, 2, 17)..DateTime.new(1989, 2, 5) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1989, 2, 6)..DateTime.new(1990, 1, 26) },
      { value: Trunc.find_by(serial_number: 7), dates: DateTime.new(1990, 1, 27)..DateTime.new(1991, 2, 14) },
      { value: Trunc.find_by(serial_number: 8), dates: DateTime.new(1991, 2, 15)..DateTime.new(1992, 2, 3) },
      { value: Trunc.find_by(serial_number: 9), dates: DateTime.new(1992, 2, 4)..DateTime.new(1993, 1, 21) },
      { value: Trunc.find_by(serial_number: 10), dates: DateTime.new(1993, 1, 22)..DateTime.new(1994, 2, 9) },

      { value: Trunc.find_by(serial_number: 1), dates: DateTime.new(1994, 2, 10)..DateTime.new(1995, 1, 29) },
      { value: Trunc.find_by(serial_number: 2), dates: DateTime.new(1995, 1, 30)..DateTime.new(1996, 2, 17) },
      { value: Trunc.find_by(serial_number: 3), dates: DateTime.new(1996, 2, 18)..DateTime.new(1997, 2, 6) },
      { value: Trunc.find_by(serial_number: 4), dates: DateTime.new(1997, 2, 7)..DateTime.new(1998, 1, 27) },
      { value: Trunc.find_by(serial_number: 5), dates: DateTime.new(1998, 1, 28)..DateTime.new(1999, 2, 15) },
      { value: Trunc.find_by(serial_number: 6), dates: DateTime.new(1999, 2, 16)..DateTime.new(2000, 2, 4) }
    ]
    ranges.find do |range|
      range[:dates].include?(date.to_date)

    end
  end



  def self.empty_trunc_year_wu_yun_definition(full_trunc)
    if
      full_trunc == Trunc.find_by(serial_number: 1)
        Trunc.find_by(serial_number: 6)
      elsif full_trunc == Trunc.find_by(serial_number: 2)
        Trunc.find_by(serial_number: 7)
      elsif full_trunc == Trunc.find_by(serial_number: 3)
        Trunc.find_by(serial_number: 8)
      elsif full_trunc == Trunc.find_by(serial_number: 4)
        Trunc.find_by(serial_number: 9)
      elsif full_trunc == Trunc.find_by(serial_number: 5)
        Trunc.find_by(serial_number: 10)
      elsif full_trunc == Trunc.find_by(serial_number: 6)
        Trunc.find_by(serial_number: 1)
      elsif full_trunc == Trunc.find_by(serial_number: 7)
        Trunc.find_by(serial_number: 2)
      elsif full_trunc == Trunc.find_by(serial_number: 8)
        Trunc.find_by(serial_number: 3)
      elsif full_trunc == Trunc.find_by(serial_number: 9)
        Trunc.find_by(serial_number: 4)
      elsif full_trunc == Trunc.find_by(serial_number: 10)
        Trunc.find_by(serial_number: 5)
    end
  end

end
