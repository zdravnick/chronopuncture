class AddColumnPaidUntilToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :paid_until, :datetime
  end
end
