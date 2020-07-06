class CreateTrunks < ActiveRecord::Migration[6.0]
  def change
    create_table :trunks do |t|
      t.string :name
      t.string :serial_number
      t.string :trunk_energy
      t.integer :year_meridian_id
      t.integer :day_meridian_id
      t.string :alias_ru
      t.string :alias_ch

      t.timestamps
    end
  end
end
