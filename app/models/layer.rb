class Layer < ApplicationRecord

  belongs_to :hand_meridian, class_name: 'Meridian'
  belongs_to :foot_meridian, class_name: 'Meridian'

  module NAMES
    JUE_YIN = 'Jue Yin'
    SHAO_YIN = 'Shao Yin'
    TAI_YIN = 'Tai Yin'
    TAI_YANG = 'Tai Yang'
    YANG_MING = 'Yang Ming'
    SHAO_YANG = 'Shao Yang'
  end

  def self.full_layer_wu_yun(date)
    ranges = {
      DateTime.new(1944, 1, 25)..DateTime.new(1944, 8, 18) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1944, 8, 19)..DateTime.new(1945, 2, 12) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1945, 2, 13)..DateTime.new(1945, 8, 7) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1945, 8, 8)..DateTime.new(1946, 2, 1) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1946, 2, 2)..DateTime.new(1946, 7, 27) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1946, 7, 28)..DateTime.new(1947, 1, 20) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1947, 1, 21)..DateTime.new(1947, 8, 15) =>  Layer::NAMES::JUE_YIN ,
      DateTime.new(1947, 8, 16)..DateTime.new(1948, 2, 9) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1948, 2, 10)..DateTime.new(1948, 8, 4) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1948, 8, 5)..DateTime.new(1949, 1, 28) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1949, 1, 29)..DateTime.new(1949, 7, 25) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1949, 7, 26)..DateTime.new(1950, 2, 16) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1950, 2, 17)..DateTime.new(1950, 8, 13) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1950, 8, 14)..DateTime.new(1951, 2, 5) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1951, 2, 6)..DateTime.new(1951, 8, 2) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1951, 8, 3)..DateTime.new(1952, 1, 26) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1952, 1, 27)..DateTime.new(1952, 8, 19) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1952, 8, 20)..DateTime.new(1953, 2, 13) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1953, 2, 14)..DateTime.new(1953, 8, 9) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1953, 8, 10)..DateTime.new(1954, 2, 2) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1954, 2, 3)..DateTime.new(1954, 7, 29) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1954, 7, 30)..DateTime.new(1955, 1, 23) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1955, 1, 24)..DateTime.new(1955, 8, 7) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1955, 8, 8)..DateTime.new(1956, 2, 11) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1956, 2, 12)..DateTime.new(1956, 8, 5) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1956, 8, 6)..DateTime.new(1957, 1, 30) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1957, 1, 31)..DateTime.new(1957, 7, 26) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1957, 7, 27)..DateTime.new(1958, 2, 17) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1958, 2, 18)..DateTime.new(1958, 7, 14) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1958, 7, 15)..DateTime.new(1959, 2, 7) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1959, 2, 8)..DateTime.new(1959, 8, 3) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1959, 8, 4)..DateTime.new(1960, 1, 27) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1960, 1, 28)..DateTime.new(1960, 8, 21) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1960, 8, 22)..DateTime.new(1961, 2, 14) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1961, 2, 15)..DateTime.new(1961, 8, 10) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1961, 8, 11)..DateTime.new(1962, 2, 4) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1962, 2, 5)..DateTime.new(1962, 7, 30) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1962, 7, 31)..DateTime.new(1963, 1, 24) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1963, 1, 25)..DateTime.new(1963, 8, 18) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1963, 8, 19)..DateTime.new(1964, 2, 12) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1964, 2, 13)..DateTime.new(1964, 8, 7) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1964, 8, 8)..DateTime.new(1965, 2, 1) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1965, 2, 2)..DateTime.new(1965, 7, 27) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1965, 7, 28)..DateTime.new(1966, 1, 20) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1966, 1, 21)..DateTime.new(1966, 8, 15) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1966, 8, 16)..DateTime.new(1967, 2, 8) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1967, 2, 9)..DateTime.new(1967, 8, 5) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1967, 8, 6)..DateTime.new(1968, 1, 29) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1968, 1, 30)..DateTime.new(1968, 7, 24) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1968, 7, 25)..DateTime.new(1969, 2, 16) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1969, 2, 17)..DateTime.new(1969, 8, 12) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1969, 8, 13)..DateTime.new(1970, 2, 5) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1970, 2, 6)..DateTime.new(1970, 8, 1) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1970, 8, 2)..DateTime.new(1971, 1, 26) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1971, 1, 27)..DateTime.new(1971, 8, 20) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1971, 8, 21)..DateTime.new(1972, 2, 14) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1972, 2, 15)..DateTime.new(1972, 8, 8) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1972, 8, 9)..DateTime.new(1973, 2, 2) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1973, 2, 3)..DateTime.new(1973, 7, 29) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1973, 7, 30)..DateTime.new(1974, 1, 22) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1971, 1, 23)..DateTime.new(1974, 8, 17) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1974, 8, 18)..DateTime.new(1975, 2, 10) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1975, 2, 11)..DateTime.new(1975, 8, 6) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1975, 8, 7)..DateTime.new(1976, 1, 30) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1976, 1, 31)..DateTime.new(1976, 7, 26) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1976, 7, 27)..DateTime.new(1977, 2, 17) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1977, 2, 18)..DateTime.new(1977, 8, 14) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1977, 8, 15)..DateTime.new(1978, 2, 6) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1978, 2, 7)..DateTime.new(1978, 8, 3) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1978, 8, 4)..DateTime.new(1979, 1, 27) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1979, 1, 28)..DateTime.new(1979, 8, 22) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1979, 8, 23)..DateTime.new(1980, 2, 15) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1980, 2, 16)..DateTime.new(1980, 8, 10) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1980, 8, 11)..DateTime.new(1981, 2, 4) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1981, 2, 5)..DateTime.new(1981, 7, 30) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1981, 7, 31)..DateTime.new(1982, 1, 24) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1982, 1, 25)..DateTime.new(1982, 8, 18) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1982, 8, 19)..DateTime.new(1983, 2, 12) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1983, 2, 13)..DateTime.new(1983, 8, 8) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1983, 8, 9)..DateTime.new(1984, 2, 1) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1984, 2, 2)..DateTime.new(1984, 7, 27) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1984, 7, 28)..DateTime.new(1985, 2, 19) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1985, 2, 20)..DateTime.new(1985, 8, 15) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1985, 8, 16)..DateTime.new(1986, 2, 8) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1986, 2, 9)..DateTime.new(1986, 8, 5) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1986, 8, 6)..DateTime.new(1987, 1, 28) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1987, 1, 29)..DateTime.new(1987, 8, 23) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1987, 8, 24)..DateTime.new(1988, 2, 16) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1988, 2, 17)..DateTime.new(1988, 8, 11) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1988, 8, 12)..DateTime.new(1989, 2, 5) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1989, 2, 6)..DateTime.new(1989, 7, 31) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1989, 8, 1)..DateTime.new(1990, 1, 26) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1990, 1, 27)..DateTime.new(1990, 8, 19) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1990, 8, 20)..DateTime.new(1991, 2, 14) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1991, 2, 15)..DateTime.new(1991, 8, 9) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1991, 8, 10)..DateTime.new(1992, 2, 3) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1992, 2, 4)..DateTime.new(1992, 7, 29) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1992, 7, 30)..DateTime.new(1993, 1, 21) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1993, 1, 22)..DateTime.new(1993, 8, 16) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1993, 8, 17)..DateTime.new(1994, 2, 9) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1994, 2, 10)..DateTime.new(1994, 8, 6) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1994, 8, 7)..DateTime.new(1995, 1, 29) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1995, 1, 30)..DateTime.new(1995, 7, 26) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1995, 7, 27)..DateTime.new(1996, 2, 17) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1996, 2, 18)..DateTime.new(1996, 8, 13) =>  Layer::NAMES::SHAO_YIN,
      DateTime.new(1996, 8, 14)..DateTime.new(1997, 2, 6) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1997, 2, 7)..DateTime.new(1997, 8, 2) =>  Layer::NAMES::TAI_YIN,
      DateTime.new(1997, 8, 3)..DateTime.new(1998, 1, 27) =>  Layer::NAMES::TAI_YANG,
      DateTime.new(1998, 1, 28)..DateTime.new(1998, 8, 21) =>  Layer::NAMES::SHAO_YANG,
      DateTime.new(1998, 8, 22)..DateTime.new(1999, 2, 15) =>  Layer::NAMES::JUE_YIN,
      DateTime.new(1999, 2, 16)..DateTime.new(1999, 8, 10) =>  Layer::NAMES::YANG_MING,
      DateTime.new(1999, 8, 11)..DateTime.new(2000, 2, 4) =>  Layer::NAMES::SHAO_YIN,
    }
    layer_name = ranges.find do |range, name|
      range.include?(date)
    end.try(:last)
    if layer_name
      Layer.find_by(name: layer_name)
    end
  end

  def self.empty_layer_wu_yun_table(full_layer)
  include NAMES
  result = []
    if full_layer.name == JUE_YIN
     result << YANG_MING
    elsif full_layer.name ==  SHAO_YIN
     result << TAI_YANG
    elsif full_layer.name ==  SHAO_YANG
     result << TAI_YANG
    elsif full_layer.name ==  TAI_YIN
     result << JUE_YIN
    elsif full_layer.name ==  TAI_YANG
     result << TAI_YIN
    elsif full_layer.name == YANG_MING
     result << [ SHAO_YIN, SHAO_YANG ]
     return result.flatten
    end
  end

  def self.empty_layer_wu_yun(empty_layer_name)
   Layer.find_by(name: empty_layer_name)
  end

end
