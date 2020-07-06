class CreateTruncs < ActiveRecord::Migration[6.0]
  def change
    create_table :truncs do |t|
      t.integer :serial_number
      t.string :name
      t.string :element
      t.integer :year_meridian_id
      t.string :alias_ru
      t.string :alias_ch

      t.timestamps
    end
  end
end
