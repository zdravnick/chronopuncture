class RenameColumnElementToOwnElementToBranch < ActiveRecord::Migration[6.0]
  def change
    rename_column :branches, :element, :own_element
  end
end
