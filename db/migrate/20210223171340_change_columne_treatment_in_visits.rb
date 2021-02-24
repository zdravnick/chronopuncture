class ChangeColumneTreatmentInVisits < ActiveRecord::Migration[6.0]
  def change
    change_column :visits, :treatment, :string, :limit => 2000
  end
end
