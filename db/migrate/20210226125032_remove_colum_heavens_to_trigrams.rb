class RemoveColumHeavensToTrigrams < ActiveRecord::Migration[6.0]
  def change
    remove_column :trigrams, :early_heaven_element, :string
    remove_column :trigrams, :later_heaven_element, :string
  end
end
