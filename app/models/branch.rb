class Branch < ApplicationRecord

  belongs_to :day_meridian, class_name: 'Meridian'

  def self.full_branch_year_wu_yun(date)
    if
      [1924, 1936, 1948, 1960, 1972, 1984, 1996,2008, 2020, 2032, 2044, 2056, 2068, 2080,
       2092].include?(date.year)
      Branch.find(1)
      elsif [1925, 1937, 1949, 1961, 1973, 1985, 1997, 2009,
        2021, 2033, 2045, 2057, 2069, 2081, 2093].include?(date.year)
        Branch.find(2)
      elsif [1926, 1938, 1950, 1962, 1974, 1986, 1998, 2010, 2022,
        2034, 2046, 2058, 2070, 2082, 2094].include?(date.year)
        Branch.find(3)
      elsif [1927, 1939, 1951, 1963, 1975, 1987, 1999,
        2011, 2023, 2035, 2047, 2059, 2071, 2083, 2095].include?(date.year)
        Branch.find(4)
      elsif [1928, 1940, 1952, 1964, 1976, 1988, 2000,
       2012, 2024, 2036, 2048, 2060, 2072, 2084, 2096].include?(date.year)
       Branch.find(5)
      elsif [1917, 1929, 1941, 1953, 1965, 1977, 1989, 2001,
       2013, 2025, 2037, 2049, 2061, 2073, 2085, 2097].include?(date.year)
       Branch.find(6)
      elsif [1918, 1930, 1942, 1954, 1966, 1978, 1990, 2002,
       2014, 2026, 2038, 2050, 2062, 2074, 2086, 2098].include?(date.year)
       Branch.find(7)
      elsif [1919, 1931, 1943, 1955, 1967, 1979,
       1991, 2003, 2015, 2027, 2039, 2051, 2063, 2075, 2087, 2099].include?(date.year)
       Branch.find(8)
      elsif [1920, 1932, 1944, 1956, 1968, 1980, 1992,
       2004, 2016, 2028, 2040, 2052, 2064, 2076, 2088, 2100].include?(date.year)
       Branch.find(9)
      elsif [1921, 1933, 1945, 1957, 1969, 1981,
       1993, 2005, 2017, 2029, 2041, 2053, 2065, 2077, 2089].include?(date.year)
       Branch.find(10)
      elsif [1922, 1934, 1946, 1958, 1970, 1982, 1994,
       2006, 2018, 2030, 2042, 2054, 2066, 2078, 2090].include?(date.year)
       Branch.find(11)
      elsif [1923, 1935, 1947, 1959, 1971, 1983, 1995, 2007, 2019, 2031, 2043, 2055, 2067, 2079, 2091].include?(date.year)
       Branch.find(12)
    end
  end

  def self.empty_branch_year_wu_yun(full_branch)
    if full_branch == Branch.find_by(serial_number: 1)
      Branch.find_by(serial_number: 7)
    elsif full_branch == Branch.find_by(serial_number: 2)
      Branch.find_by(serial_number: 8)
    elsif full_branch == Branch.find_by(serial_number: 3)
      Branch.find_by(serial_number: 9)
    elsif full_branch == Branch.find_by(serial_number: 4)
      Branch.find_by(serial_number: 10)
    elsif full_branch == Branch.find_by(serial_number: 5)
      Branch.find_by(serial_number: 11)
    elsif full_branch == Branch.find_by(serial_number: 6)
      Branch.find_by(serial_number: 12)
    elsif full_branch == Branch.find_by(serial_number: 7)
      Branch.find_by(serial_number: 1)
    elsif full_branch == Branch.find_by(serial_number: 8)
      Branch.find_by(serial_number: 2)
    elsif full_branch == Branch.find_by(serial_number: 9)
      Branch.find_by(serial_number: 3)
    elsif full_branch == Branch.find_by(serial_number: 10)
      Branch.find_by(serial_number: 4)
    elsif full_branch == Branch.find_by(serial_number: 11)
      Branch.find_by(serial_number: 5)
    elsif full_branch == Branch.find_by(serial_number: 12)
      Branch.find_by(serial_number: 6)
    end
  end

end
