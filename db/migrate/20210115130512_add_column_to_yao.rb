class AddColumnToYao < ActiveRecord::Migration[6.0]
  def change
    add_column :yaos, :name, :string
    add_column :yaos, :age, :string
  end
end
