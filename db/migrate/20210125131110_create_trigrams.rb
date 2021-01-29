class CreateTrigrams < ActiveRecord::Migration[6.0]
  def change
    create_table :trigrams do |t|
      t.string :name
      t.string :alias_ru
      t.string :alias_cn
      t.string :line_1
      t.string :line_2
      t.string :line_3

      t.timestamps
    end
  end
end
