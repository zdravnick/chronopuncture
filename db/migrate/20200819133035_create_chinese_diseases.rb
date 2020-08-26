class CreateChineseDiseases < ActiveRecord::Migration[6.0]
  def change
    create_table :chinese_diseases do |t|
      t.string :name

      t.timestamps
    end
  end
end
