class AddPhoneToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :phone, :string
  end
end
