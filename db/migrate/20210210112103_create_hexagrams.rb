class CreateHexagrams < ActiveRecord::Migration[6.0]
  def change
    create_table :hexagrams do |t|
      t.string :name
      t.integer :lower_trigram_id
      t.integer :upper_trigram_id
      t.boolean :favorable
      t.integer :meridian_id
      t.timestamps
    end
  end
end
