class RemoveFieldsFromTutorships < ActiveRecord::Migration
  def change
    remove_column :tutorships, :tutor_id, :integer
    remove_column :tutorships, :student_id, :integer
    remove_column :tutorships, :subject_id, :integer
  end
end
