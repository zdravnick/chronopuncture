class ChineseDiseasesPatient < ApplicationRecord
  belongs_to :patient
  belongs_to :chinese_disease

  module Kinds
    TONGUE = 'tongue'
    PULSE = 'pulse'
  end

  scope :tongue, -> { where(kind: Kinds::TONGUE) }
  scope :pulse, -> { where(kind: Kinds::PULSE) }
end
