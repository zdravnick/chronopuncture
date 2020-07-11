class AddColumnFunctionToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points, :function, :string
  end
end
