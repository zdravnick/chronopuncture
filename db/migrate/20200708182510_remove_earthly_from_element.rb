class RemoveEarthlyFromElement < ActiveRecord::Migration[6.0]
  def change

    remove_column :elements, :earthly, :boolean
  end
end
