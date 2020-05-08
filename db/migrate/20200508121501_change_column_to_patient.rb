class ChangeColumnToPatient < ActiveRecord::Migration[6.0]
  def change
  change_column  :patients, :birthdate, :datetime
  end
end
