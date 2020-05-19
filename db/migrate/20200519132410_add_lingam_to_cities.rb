class AddLingamToCities < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :time_zone, :string, default: 'UTC'
  end
end
