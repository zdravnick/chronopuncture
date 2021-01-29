class RemoveColumnesLineFromTrigrams < ActiveRecord::Migration[6.0]
  def change
    remove_column :trigrams, :line_1_id, :string
    remove_column :trigrams, :line_2_id, :string
    remove_column :trigrams, :line_3_id, :string
  end
end
