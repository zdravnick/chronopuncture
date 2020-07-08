class Meridian < ApplicationRecord

  has_many :elements, class_name: 'Element'

end
