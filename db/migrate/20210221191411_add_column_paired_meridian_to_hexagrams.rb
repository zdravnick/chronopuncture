class AddColumnPairedMeridianToHexagrams < ActiveRecord::Migration[6.0]
  def change
    add_column :hexagrams, :paired_meridian_id, :integer
  end
end
