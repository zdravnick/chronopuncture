class Trunk < ApplicationRecord

  belongs_to :year_meridian, class_name: 'Meridian'

  def self.trunk_year_wu_yun_definition(date)
    ranges = [
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1938, 1, 31)..DateTime.new(1939, 2, 18) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1939, 2, 19)..DateTime.new(1940, 2, 7) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1940, 2, 8)..DateTime.new(1941, 1, 26) },

      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1941, 1, 27)..DateTime.new(1942, 2, 14) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1942, 2, 15)..DateTime.new(1943, 2, 4) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1943, 2, 5)..DateTime.new(1944, 1, 24) },
      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1944, 1, 25)..DateTime.new(1945, 2, 12) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1945, 2, 13)..DateTime.new(1946, 2, 1) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1946, 2, 2)..DateTime.new(1947, 1, 20) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1947, 1, 21)..DateTime.new(1948, 2, 9) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1948, 2, 10)..DateTime.new(1949, 1, 28) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1949, 1, 29)..DateTime.new(1950, 2, 16) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1950, 2, 17)..DateTime.new(1951, 2, 5) },
      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1951, 2, 6)..DateTime.new(1952, 1, 26) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1952, 1, 27)..DateTime.new(1953, 2, 13) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1953, 2, 14)..DateTime.new(1954, 2, 2) },

      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1954, 2, 3)..DateTime.new(1955, 1, 23) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1955, 1, 24)..DateTime.new(1956, 2, 11) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1956, 2, 12)..DateTime.new(1957, 1, 30) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1957, 1, 31)..DateTime.new(1958, 2, 17) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1958, 2, 18)..DateTime.new(1959, 2, 7) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1959, 2, 8)..DateTime.new(1960, 1, 27) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1960, 1, 28)..DateTime.new(1961, 2, 14) },
      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1961, 2, 15)..DateTime.new(1962, 2, 4) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1962, 2, 5)..DateTime.new(1963, 1, 24) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1963, 1, 25)..DateTime.new(1964, 2, 12) },

      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1964, 2, 13)..DateTime.new(1965, 2, 1) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1965, 2, 2)..DateTime.new(1966, 1, 20) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1966, 1, 21)..DateTime.new(1967, 2, 8) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1967, 2, 9)..DateTime.new(1968, 1, 29) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1968, 1, 30)..DateTime.new(1969, 2, 16) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1969, 2, 17)..DateTime.new(1970, 2, 5) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1970, 2, 6)..DateTime.new(1971, 1, 26) },
      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1971, 1, 27)..DateTime.new(1972, 2, 14) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1972, 2, 15)..DateTime.new(1973, 2, 2) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1973, 2, 3)..DateTime.new(1974, 1, 22) },

      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1974, 1, 23)..DateTime.new(1975, 2, 10) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1975, 2, 11)..DateTime.new(1976, 1, 30) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1976, 1, 31)..DateTime.new(1977, 2, 17) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1977, 2, 18)..DateTime.new(1978, 2, 6) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1978, 2, 7)..DateTime.new(1979, 1, 27) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1979, 1, 28)..DateTime.new(1980, 2, 15) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1980, 2, 16)..DateTime.new(1981, 2, 4) },
      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1981, 2, 5)..DateTime.new(1982, 1, 24) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1982, 1, 25)..DateTime.new(1983, 2, 12) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1983, 2, 13)..DateTime.new(1984, 2, 1) },

      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1984, 2, 2)..DateTime.new(1985, 2, 19) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1985, 2, 20)..DateTime.new(1986, 2, 8) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1986, 2, 9)..DateTime.new(1987, 1, 28) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1987, 1, 29)..DateTime.new(1988, 2, 16) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1988, 2, 17)..DateTime.new(1989, 2, 5) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1989, 2, 6)..DateTime.new(1990, 1, 26) },
      { value: Trunk.find_by(serial_number: 7), dates: DateTime.new(1990, 1, 27)..DateTime.new(1991, 2, 14) },
      { value: Trunk.find_by(serial_number: 8), dates: DateTime.new(1991, 2, 15)..DateTime.new(1992, 2, 3) },
      { value: Trunk.find_by(serial_number: 9), dates: DateTime.new(1992, 2, 4)..DateTime.new(1993, 1, 21) },
      { value: Trunk.find_by(serial_number: 10), dates: DateTime.new(1993, 1, 22)..DateTime.new(1994, 2, 9) },

      { value: Trunk.find_by(serial_number: 1), dates: DateTime.new(1994, 2, 10)..DateTime.new(1995, 1, 29) },
      { value: Trunk.find_by(serial_number: 2), dates: DateTime.new(1995, 1, 30)..DateTime.new(1996, 2, 17) },
      { value: Trunk.find_by(serial_number: 3), dates: DateTime.new(1996, 2, 18)..DateTime.new(1997, 2, 6) },
      { value: Trunk.find_by(serial_number: 4), dates: DateTime.new(1997, 2, 7)..DateTime.new(1998, 1, 27) },
      { value: Trunk.find_by(serial_number: 5), dates: DateTime.new(1998, 1, 28)..DateTime.new(1999, 2, 15) },
      { value: Trunk.find_by(serial_number: 6), dates: DateTime.new(1999, 2, 16)..DateTime.new(2000, 2, 4) }
    ]
    ranges.find do |range|
      range[:dates].include?(date.to_date)
    end
  end

  def self.empty_trunk_year_wu_yun_definition(full_trunk)
    if
      full_trunk == Trunk.find_by(serial_number: 1)
        Trunk.find_by(serial_number: 6)
      elsif full_trunk == Trunk.find_by(serial_number: 2)
        Trunk.find_by(serial_number: 7)
      elsif full_trunk == Trunk.find_by(serial_number: 3)
        Trunk.find_by(serial_number: 8)
      elsif full_trunk == Trunk.find_by(serial_number: 4)
        Trunk.find_by(serial_number: 9)
      elsif full_trunk == Trunk.find_by(serial_number: 5)
        Trunk.find_by(serial_number: 10)
      elsif full_trunk == Trunk.find_by(serial_number: 6)
        Trunk.find_by(serial_number: 1)
      elsif full_trunk == Trunk.find_by(serial_number: 7)
        Trunk.find_by(serial_number: 2)
      elsif full_trunk == Trunk.find_by(serial_number: 8)
        Trunk.find_by(serial_number: 3)
      elsif full_trunk == Trunk.find_by(serial_number: 9)
        Trunk.find_by(serial_number: 4)
      elsif full_trunk == Trunk.find_by(serial_number: 10)
        Trunk.find_by(serial_number: 5)
      else
    end
  end

end
