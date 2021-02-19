class AddColumnesLineToHexagrams < ActiveRecord::Migration[6.0]
  def change
    add_column :hexagrams, :line_1_id, :integer
    add_column :hexagrams, :line_2_id, :integer
    add_column :hexagrams, :line_3_id, :integer
    add_column :hexagrams, :line_4_id, :integer
    add_column :hexagrams, :line_5_id, :integer
    add_column :hexagrams, :line_6_id, :integer
  end
end
