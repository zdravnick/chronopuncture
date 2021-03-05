class AddColumHeavenToTrigrams < ActiveRecord::Migration[6.0]
  def change
    add_column :trigrams, :nature, :string
  end
end
