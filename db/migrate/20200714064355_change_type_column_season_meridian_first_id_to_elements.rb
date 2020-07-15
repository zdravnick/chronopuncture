class ChangeTypeColumnSeasonMeridianFirstIdToElements < ActiveRecord::Migration[6.0]
  def change
    rename_column :elements, :season_meridian_id, :season_meridian_first_id
  end
end
