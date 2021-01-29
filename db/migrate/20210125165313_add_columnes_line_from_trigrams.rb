class AddColumnesLineFromTrigrams < ActiveRecord::Migration[6.0]
  def change
    add_column :trigrams, :line_1_id, :integer
    add_column :trigrams, :line_2_id, :integer
    add_column :trigrams, :line_3_id, :integer
  end
end
