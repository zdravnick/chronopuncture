class AddDescriptionToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :description, :text
  end
end
