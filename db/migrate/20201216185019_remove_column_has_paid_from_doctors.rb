class RemoveColumnHasPaidFromDoctors < ActiveRecord::Migration[6.0]
  def change
    remove_column :doctors, :has_paid, :boolean
  end
end
