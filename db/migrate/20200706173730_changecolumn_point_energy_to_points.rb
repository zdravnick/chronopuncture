class ChangecolumnPointEnergyToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points,  :own_element_id, :integer
  end
end
