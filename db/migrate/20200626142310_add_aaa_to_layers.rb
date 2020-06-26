class AddAaaToLayers < ActiveRecord::Migration[6.0]
  def change
    add_column :layers, :foot_meridian_id, :integer, null: false, default: 0
    add_column :layers, :hand_meridian_id, :integer, null: false, default: 0
  end
end
