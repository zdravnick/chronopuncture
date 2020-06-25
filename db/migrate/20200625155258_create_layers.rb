class CreateLayers < ActiveRecord::Migration[6.0]
  def change
    create_table :layers do |t|
      t.string :name
      t.string :foot_meridian_name
      t.string :hand_meridian_name
      t.string :foot_meridian_element
      t.string :hand_meridian_element

      t.timestamps
    end
    add_index :layers, :name
  end
end
