class AddColumnMeridianIdToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points, :meridian_id, :integer
  end
end
