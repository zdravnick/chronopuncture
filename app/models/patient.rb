class Patient < ApplicationRecord

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 20 },
                   uniqueness: true
  belongs_to :doctor

end
