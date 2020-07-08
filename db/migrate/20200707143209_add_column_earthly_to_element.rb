class AddColumnEarthlyToElement < ActiveRecord::Migration[6.0]
  def change
    add_column :elements, :earthly, :boolean
  end
end
