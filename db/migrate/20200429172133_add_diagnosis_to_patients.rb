class AddDiagnosisToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :diagnosis, :string
  end
end
