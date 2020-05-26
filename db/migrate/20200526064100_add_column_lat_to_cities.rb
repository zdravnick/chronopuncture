class AddColumnLatToCities < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :lat, :float
  end
end
