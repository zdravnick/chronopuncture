class ChangeColumnCityToPatientToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :patients, :city_id, :integer
  end
end
