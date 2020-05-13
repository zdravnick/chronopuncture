class AddCityToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :city, :string
  end
end
