class ChangeColumnCityToDoctorToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :doctors, :city_id, :integer
  end
end
