class DropTruncTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :truncs
  end
end
