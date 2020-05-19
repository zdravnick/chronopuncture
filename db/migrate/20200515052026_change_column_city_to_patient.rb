class ChangeColumnCityToPatient < ActiveRecord::Migration[6.0]
  def change
    rename_column :patients, :city, :city_id
  end
end
