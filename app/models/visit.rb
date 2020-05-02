class Visit < ApplicationRecord

  validates :treatment, presence: true,
              length: { minimum: 5}

  belongs_to :patient
end
