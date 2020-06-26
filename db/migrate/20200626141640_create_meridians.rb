class CreateMeridians < ActiveRecord::Migration[6.0]
  def change
    create_table :meridians do |t|
      t.string :name
      t.string :energy_name
      t.string :element_trunc
      t.string :element_brunch
      t.string :element_ke
      t.string :alias_ru
      t.string :short_name_en

      t.timestamps
    end
  end
end
