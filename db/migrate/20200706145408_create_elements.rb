class CreateElements < ActiveRecord::Migration[6.0]
  def change
    create_table :elements do |t|
      t.string :name
      t.string :yin_yang

      t.timestamps
    end
  end
end
