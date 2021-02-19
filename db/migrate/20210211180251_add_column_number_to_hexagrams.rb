class AddColumnNumberToHexagrams < ActiveRecord::Migration[6.0]
  def change
    add_column :hexagrams, :number, :integer
  end
end
