class Layer < ApplicationRecord

  belongs_to :hand_meridian, class_name: 'Meridian'
  belongs_to :foot_meridian, class_name: 'Meridian'

  module NAMES
    JUE_YIN = 'Jue Yin'
    SHAO_YIN = 'Shao Yin'
    TAI_YIN = 'Tai Yin'
    TAI_YANG = 'Tai Yang'
    YANG_MING = 'Yang Ming'
    SHAO_YANG = 'Shao Yang'
  end

  def self.full_layer_wu_yun(date)
    ranges = {
      DateTime.new(1974, 8, 18)..DateTime.new(1975, 2, 10) =>  Layer::NAMES::JUE_YIN
    }
    layer_name = ranges.find do |range, name|
      range.include?(date)
    end.try(:last)
    if layer_name
      Layer.find_by(name: layer_name)
    end
  end

end
