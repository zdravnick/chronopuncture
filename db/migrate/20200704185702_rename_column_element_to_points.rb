class RenameColumnElementToPoints < ActiveRecord::Migration[6.0]
  def change
    rename_column :points, :element, :point_energy
  end
end
