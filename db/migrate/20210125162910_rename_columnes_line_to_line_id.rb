class RenameColumnesLineToLineId < ActiveRecord::Migration[6.0]
  def change
    rename_column :trigrams, :line_1, :line_1_id
    rename_column :trigrams, :line_2, :line_2_id
    rename_column :trigrams, :line_3, :line_3_id
  end
end
