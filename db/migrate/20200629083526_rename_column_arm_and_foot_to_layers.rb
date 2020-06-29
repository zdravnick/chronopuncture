class RenameColumnArmAndFootToLayers < ActiveRecord::Migration[6.0]
  def change
    rename_column :layers, :foot_meridian_name, :leg_meridian_name
    rename_column :layers, :arm_meridian_name, :arm_meridian_name
    rename_column :layers, :foot_meridian_element, :leg_meridian_element
    rename_column :layers, :arm_meridian_element, :arm_meridian_element
    rename_column :layers, :foot_meridian_id, :leg_meridian_id
    rename_column :layers, :arm_meridian_id, :arm_meridian_id
  end
end
