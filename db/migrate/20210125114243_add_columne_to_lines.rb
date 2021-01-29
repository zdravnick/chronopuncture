class AddColumneToLines < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :dotted_solid, :string
  end
end
