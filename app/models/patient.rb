class Patient < ApplicationRecord

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 50 }
  belongs_to :doctor
  has_one :city
  has_many :visits, dependent: :destroy

end
