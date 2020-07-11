class AddColumnSerialnumberToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points, :serial_number, :integer
  end
end
