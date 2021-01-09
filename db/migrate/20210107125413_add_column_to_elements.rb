class AddColumnToElements < ActiveRecord::Migration[6.0]
  def change
    add_column :elements, :alias_ru, :string
  end
end
