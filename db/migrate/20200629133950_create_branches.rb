class CreateBranches < ActiveRecord::Migration[6.0]
  def change
    create_table :branches do |t|
      t.integer :serial_number
      t.string :name
      t.integer :active_hour_offset
      t.string :element
      t.string :animal
      t.string :alias_ru
      t.string :alias_ch

      t.timestamps
    end
  end
end
