class AddColumnDayMeridianIdToBranch < ActiveRecord::Migration[6.0]
  def change
    add_column :branches, :day_meridian_id, :integer
  end
end
