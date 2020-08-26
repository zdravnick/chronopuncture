class CreatePatientChineseDiseases < ActiveRecord::Migration[6.0]
  def change
    create_table :chinese_diseases_patients do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :chinese_disease, null: false, foreign_key: true

      t.timestamps
    end
  end
end
