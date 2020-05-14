class ChangeColumnPatientIdToCity < ActiveRecord::Migration[6.0]
  def change
    change_column_null :cities, :patient_id, true
  end
end
