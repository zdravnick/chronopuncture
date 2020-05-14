class ChangeColumnDoctorIdToCity < ActiveRecord::Migration[6.0]
  def change
    change_column_null :cities, :doctor_id, true
  end
end
