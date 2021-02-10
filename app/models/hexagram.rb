class Hexagram < ApplicationRecord
  scope :hexagrams, -> { where(favorable: true) }

  belongs_to :lower_trigram, class_name: 'Trigram'
  belongs_to :upper_trigram, class_name: 'Trigram'
  belongs_to :meridian, optional: true

  def favorable_with_hexagrams(hexagrams)
    hexagrams.favorable.select do |other_hexagram|
      favorable_lines_count = 0
      favorable_lines_count += 1 if other_hexagram.lower_trigram.line_1.yin_yang ==  self.lower_trigram.line_1.yin_yang
      favorable_lines_count += 1 if other_hexagram.lower_trigram.line_2.yin_yang ==  self.lower_trigram.line_2.yin_yang
      favorable_lines_count += 1 if other_hexagram.lower_trigram.line_3.yin_yang ==  self.lower_trigram.line_3.yin_yang
      favorable_lines_count += 1 if other_hexagram.upper_trigram.line_1.yin_yang ==  self.upper_trigram.line_1.yin_yang
      favorable_lines_count += 1 if other_hexagram.upper_trigram.line_2.yin_yang ==  self.upper_trigram.line_2.yin_yang
      favorable_lines_count += 1 if other_hexagram.upper_trigram.line_3.yin_yang ==  self.upper_trigram.line_3.yin_yang

      favorable_lines_count >= FAVORABLE_LINES_COUNT
    end
  end

end
