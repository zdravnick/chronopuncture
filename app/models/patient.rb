class Patient < ApplicationRecord
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 50 }
  belongs_to :doctor
  belongs_to :city
  has_many :visits, dependent: :destroy

  has_many :chinese_diseases_patients
  has_many :pulse_chinese_diseases_patients, -> { pulse }, class_name: 'ChineseDiseasesPatient'
  has_many :tongue_chinese_diseases_patients, -> { tongue }, class_name: 'ChineseDiseasesPatient'

  has_many :chinese_diseases, -> { distinct }, through: :chinese_diseases_patients
  has_many :pulse_chinese_diseases, through: :pulse_chinese_diseases_patients, source: :chinese_disease
  has_many :tongue_chinese_diseases, through: :tongue_chinese_diseases_patients, source: :chinese_disease
  # accepts_nested_attributes_for :pulse_chinese_diseases, :allow_destroy => true
  # accepts_nested_attributes_for :tongue_chinese_diseases, :allow_destroy => true

  def total_element_influence(element)
    chinese_diseases.map do |chinese_disease|
      chinese_disease.influences.where(element_id: element.id).sum(:influence)
    end.sum
  end
end