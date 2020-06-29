class Trunc < ApplicationRecord

  belongs_to :year_meridian, class_name: 'Meridian'

  def self.trunc_year_wu_yun_definition_probe(date)
    if
      [1924, 1934, 1944, 1954, 1964, 1974, 1984, 1994, 2004, 2014, 2024, 2034, 2044, 2054,
        2064, 2074, 2084, 2094].include?(date.year)
      Trunc.all.find_by(serial_number: 1)
      elsif [1925, 1935, 1945, 1955, 1965, 1975, 1985, 1995,
       2005, 2015, 2025, 2035, 2045, 2055, 2065, 2075, 2085, 2095].include?(date.year)
       Trunc.all.find_by(serial_number: 2)
      elsif [1926, 1936, 1946, 1956, 1966, 1976,
       1986, 1996, 2006, 2016, 2026, 2036, 2046, 2056, 2066, 2076, 2086, 2096].include?(date.year)
       Trunc.all.find_by(serial_number: 3)
      elsif [1927, 1937, 1947, 1957, 1967, 1977,
       1987, 1997, 2007, 2017, 2027, 2037, 2047, 2057, 2067, 2077, 2087, 2097].include?(date.year)
       Trunc.all.find_by(serial_number: 4)
      elsif [1928, 1938, 1948, 1958, 1968, 1978,
       1988, 1998, 2008, 2018, 2028, 2038, 2048, 2058, 2068, 2078, 2088, 2098].include?(date.year)
       Trunc.all.find_by(serial_number: 5)
      elsif [1929, 1939, 1949, 1959, 1969, 1979,
       1989, 1999, 2009, 2019, 2029, 2039, 2049, 2059, 2069, 2079, 2089, 2099].include?(date.year)
       Trunc.all.find_by(serial_number: 6)
      elsif [1920, 1930, 1940, 1950, 1960, 1970,
       1980, 1990, 2000, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100].include?(date.year)
       Trunc.all.find_by(serial_number: 7)
      elsif [1921, 1931, 1941, 1951, 1961, 1971,
       1981, 1991, 2001, 2011, 2021, 2031, 2041, 2051, 2061, 2071, 2081, 2091, 2101].include?(date.year)
       Trunc.all.find_by(serial_number: 8)
      elsif [1922, 1932, 1942, 1952, 1962, 1972,
       1982, 1992, 2002, 2012, 2022, 2032, 2042, 2052, 2062, 2072, 2082, 2092, 2102].include?(date.year)
       Trunc.all.find_by(serial_number: 9)
      elsif [1923, 1933, 1943, 1953, 1963, 1973,
      1983, 1993, 2003, 2013, 2023, 2033, 2043, 2053, 2063, 2073, 2083, 2093, 2103].include?(date.year)
      Trunc.all.find_by(serial_number: 10)
    end
  end
  def self.empty_trunc_year_wu_yun_definition_probe(full_trunc)
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
