class Patient < ApplicationRecord

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 20 },
                   uniqueness: true
  belongs_to :doctor
  has_many :visits, dependent: :destroy

end
