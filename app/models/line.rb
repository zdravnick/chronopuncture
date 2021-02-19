class Line < ApplicationRecord

  has_many :trigrams
  has_many :hexagrams
  belongs_to :point, optional: true

end
