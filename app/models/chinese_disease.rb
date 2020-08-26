class ChineseDisease < ApplicationRecord
  has_many :influences, class_name: 'ChineseDiseaseElementInfluence'
end
