class ChangeColumnCityToDoctor < ActiveRecord::Migration[6.0]
  def change
    rename_column :doctors, :city, :city_id
  end
end
