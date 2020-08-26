class AddColumnKindTochineseDiseasePatient < ActiveRecord::Migration[6.0]
  def change
    add_column :chinese_diseases_patients, :kind, :string
  end
end
