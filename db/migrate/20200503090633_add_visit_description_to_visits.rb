class AddVisitDescriptionToVisits < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :visit_description, :text
  end
end
