class Element < ApplicationRecord

  belongs_to :wu_xing_meridian, class_name: 'Meridian'
  belongs_to :season_meridian_first, class_name: 'Meridian'
  belongs_to :season_meridian_second, class_name: 'Meridian'
  belongs_to :trunk_meridian, class_name: 'Meridian'
  has_many :layers, class_name: 'Layer'

  # def energy_balance(points)
  #   points.map do |point|
  #     case point.id
  #     when 1
  #       case id
  #       when 1
  #         -10
  #       when 2
  #         10
  #       when 3
  #         0
  #       end

  #     end
  #   end.compact.sum
  # end


end
