class Meridian < ApplicationRecord

  has_many :elements, class_name: 'Element'
  has_many :points, class_name: 'Point'
  # has_many :hexagrams, class_name: 'Hexagram'


end
