class RenameColumnElementTruncToMeridian < ActiveRecord::Migration[6.0]
  def change
    rename_column :meridians, :element_trunc, :element_trunk
  end
end
