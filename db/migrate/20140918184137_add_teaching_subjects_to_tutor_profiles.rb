class AddTeachingSubjectsToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :teaching_subject_2, :string
    add_column :tutor_profiles, :teaching_subject_3, :string
  end
end
