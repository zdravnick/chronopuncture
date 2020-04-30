class ChangeTableDoctors < ActiveRecord::Migration[6.0]
 def change
    add_column :doctors, :moderator, :boolean, default: false
    add_column :doctors, :birthday, :date
    add_column :doctors, :banned, :boolean, default: false
    add_column :doctors, :avatar, :string
  end
end
