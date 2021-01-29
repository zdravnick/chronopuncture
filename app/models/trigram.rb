class Trigram < ApplicationRecord

  belongs_to :line_1, class_name: 'Line'
  belongs_to :line_2, class_name: 'Line'
  belongs_to :line_3, class_name: 'Line'

end
