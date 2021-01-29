class AddColumnTrigramIdToLines < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :trigram_id, :integer
  end
end
