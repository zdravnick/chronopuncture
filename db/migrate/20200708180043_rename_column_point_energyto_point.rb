class RenameColumnPointEnergytoPoint < ActiveRecord::Migration[6.0]
  def change
    rename_column :points, :point_energy, :own_element
  end
end
