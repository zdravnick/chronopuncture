class AddColumnesPointsIdToHexagrams < ActiveRecord::Migration[6.0]
  def change
    add_column :hexagrams, :line_1_point_id, :integer
    add_column :hexagrams, :line_2_point_id, :integer
    add_column :hexagrams, :line_3_point_id, :integer
    add_column :hexagrams, :line_4_point_id, :integer
    add_column :hexagrams, :line_5_point_id, :integer
    add_column :hexagrams, :line_6_point_id, :integer
  end
end
