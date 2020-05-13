class AddCityToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :city, :string
  end
end
