class AddColumnOwnElementIdToLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :layers, :own_element_id, :integer
  end
end
