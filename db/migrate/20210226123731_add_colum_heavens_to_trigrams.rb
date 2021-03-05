class AddColumHeavensToTrigrams < ActiveRecord::Migration[6.0]
  def change
    add_column :trigrams, :early_heaven_element, :string
    add_column :trigrams, :later_heaven_element, :string
  end
end
