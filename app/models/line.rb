class Line < ApplicationRecord

  has_many :trigrams
  belongs_to :point, optional: true

end
