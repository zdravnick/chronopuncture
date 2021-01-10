class AddColumnToTrunks < ActiveRecord::Migration[6.0]
  def change
    add_column :trunks, :forbidden_action_by_days, :string
  end
end
