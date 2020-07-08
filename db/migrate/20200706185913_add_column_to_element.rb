class AddColumnToElement < ActiveRecord::Migration[6.0]
  def change
    add_column :elements, :wu_xing_meridian_id, :integer
    add_column :elements, :season_meridian_id, :integer
    add_column :elements, :trunk_meridian_id, :integer
    add_column :elements, :layer_id, :integer
  end
end
