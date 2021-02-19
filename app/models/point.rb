class Point < ApplicationRecord
  validates_presence_of :name

  # def self.find_by_first_letter(letter)
  #   find(:all, conditions: ['name LIKE ?', "#{letter}%"], order: 'name ASC')
  # end

  belongs_to :meridian, optional: true
  has_many :lines
  has_many :hexagrams

end
