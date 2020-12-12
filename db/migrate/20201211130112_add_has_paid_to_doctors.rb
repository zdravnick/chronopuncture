class AddHasPaidToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :has_paid, :boolean, default: false, null:false
  end
end
