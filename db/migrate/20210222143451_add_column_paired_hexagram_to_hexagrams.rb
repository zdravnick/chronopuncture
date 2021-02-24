class AddColumnPairedHexagramToHexagrams < ActiveRecord::Migration[6.0]
  def change
    add_column :hexagrams, :paired_hexagram_id, :integer
  end
end
