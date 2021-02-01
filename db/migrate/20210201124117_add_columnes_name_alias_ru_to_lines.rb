class AddColumnesNameAliasRuToLines < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :name, :string
    add_column :lines, :alias_ru, :string
  end
end
