class Element < ApplicationRecord

  belongs_to :wu_xing_meridian, class_name: 'Meridian'
  belongs_to :season_meridian, class_name: 'Meridian'
  belongs_to :trunk_meridian, class_name: 'Meridian'
  has_many :layers, class_name: 'Layer'


end
