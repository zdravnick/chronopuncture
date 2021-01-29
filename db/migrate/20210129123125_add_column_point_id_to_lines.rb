class AddColumnPointIdToLines < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :point_id, :integer
  end
end
