class DestroyModelYao < ActiveRecord::Migration[6.0]
  def change
    drop_table :yaos
  end
end
