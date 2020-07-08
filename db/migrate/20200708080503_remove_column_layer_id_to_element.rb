class RemoveColumnLayerIdToElement < ActiveRecord::Migration[6.0]
  def change
    remove_column :elements, :layer_id
  end
end
