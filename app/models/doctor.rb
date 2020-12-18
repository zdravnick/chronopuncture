class Doctor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :name, presence: true
  # #                  length: { minimum: 2, maximum: 20 },
  # #                  uniqueness: true
  validates :email, presence: true,
                    uniqueness: true

  belongs_to :city

  has_many :patients do # @doctor.patients.active
    def active
      if proxy_association.owner.paid_period_seconds_left > 0 || proxy_association.owner.moderator?
        self
      else
        self.where(id: self.first.try(:id))
      end
    end
  end

  has_many :visits, through: :patients

  def paid_period_seconds_left
    return 0 if self.paid_until == nil
    return 0 if self.paid_until <= DateTime.current
    self.paid_until.to_i - DateTime.current.to_i
  end

end

