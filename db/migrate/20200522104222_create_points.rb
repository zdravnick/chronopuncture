class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.string :name
      t.string :alias_en
      t.string :alias_ru
      t.string :alias_cn
      t.string :element

      t.timestamps
    end
    add_index :points, :name
  end
end
