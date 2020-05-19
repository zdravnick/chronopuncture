class Doctor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  #                  length: { minimum: 2, maximum: 20 },
  #                  uniqueness: true
  validates :email, presence: true,
                    uniqueness: true

  belongs_to :city
  has_many :patients
  has_many :visits, through: :patients


end

