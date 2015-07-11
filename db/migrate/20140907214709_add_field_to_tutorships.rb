class AddFieldToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :created_by_student, :boolean
  end
end
