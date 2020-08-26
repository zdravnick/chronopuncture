class CreateChineseDiseaseElementInfluences < ActiveRecord::Migration[6.0]
  def change
    create_table :chinese_disease_element_influences do |t|
      t.references :chinese_disease, null: false, foreign_key: true
      t.references :element, null: false, foreign_key: true
      t.integer :influence

      t.timestamps
    end
  end
end
