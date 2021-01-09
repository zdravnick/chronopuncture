class AddColumnAliasRuToLayers < ActiveRecord::Migration[6.0]
  def change
    add_column :layers, :alias_ru, :string
  end
end
