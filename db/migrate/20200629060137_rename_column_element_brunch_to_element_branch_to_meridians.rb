class RenameColumnElementbranchToElementBranchToMeridians < ActiveRecord::Migration[6.0]
  def change
    rename_column :meridians, :element_branch, :element_branch
  end
end
