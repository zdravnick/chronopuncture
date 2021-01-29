class Line < ApplicationRecord

  has_many :trigrams
  belongs_to :point

end
