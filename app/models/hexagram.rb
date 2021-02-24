class Hexagram < ApplicationRecord



  scope :favorable, -> { where(favorable: true) }

  belongs_to :lower_trigram, class_name: 'Trigram', optional: true
  belongs_to :upper_trigram, class_name: 'Trigram', optional: true
  belongs_to :meridian, optional: true
  belongs_to :paired_meridian, class_name: 'Meridian', optional: true
  belongs_to :paired_hexagram, class_name: 'Hexagram', optional: true

  belongs_to :line_1, class_name: 'Line', optional: true
  belongs_to :line_2, class_name: 'Line', optional: true
  belongs_to :line_3, class_name: 'Line', optional: true
  belongs_to :line_4, class_name: 'Line', optional: true
  belongs_to :line_5, class_name: 'Line', optional: true
  belongs_to :line_6, class_name: 'Line', optional: true

  belongs_to :line_1_point, class_name: 'Point', optional: true
  belongs_to :line_2_point, class_name: 'Point', optional: true
  belongs_to :line_3_point, class_name: 'Point', optional: true
  belongs_to :line_4_point, class_name: 'Point', optional: true
  belongs_to :line_5_point, class_name: 'Point', optional: true
  belongs_to :line_6_point, class_name: 'Point', optional: true


  FAVORABLE_LINES_COUNT = 4

  def favorable_with_hexagrams(hexagrams)

    hexagrams.select do |other_hexagram|
      favorable_lines_count = 0
      favorable_lines_count += 1 if other_hexagram.line_1.yin_yang == self.line_1.yin_yang
      favorable_lines_count += 1 if other_hexagram.line_2.yin_yang == self.line_2.yin_yang
      favorable_lines_count += 1 if other_hexagram.line_3.yin_yang == self.line_3.yin_yang
      favorable_lines_count += 1 if other_hexagram.line_4.yin_yang == self.line_4.yin_yang
      favorable_lines_count += 1 if other_hexagram.line_5.yin_yang == self.line_5.yin_yang
      favorable_lines_count += 1 if other_hexagram.line_6.yin_yang == self.line_6.yin_yang
      favorable_lines_count >= FAVORABLE_LINES_COUNT
    end
  end

end
