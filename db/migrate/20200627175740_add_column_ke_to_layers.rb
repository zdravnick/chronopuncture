class AddColumnKeToLayers < ActiveRecord::Migration[6.0]
  def change
    add_column :layers, :element_ke, :string
  end
end
