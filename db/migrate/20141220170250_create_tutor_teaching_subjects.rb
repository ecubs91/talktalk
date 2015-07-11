class CreateTutorTeachingSubjects < ActiveRecord::Migration
  def change
    create_table :tutor_teaching_subjects do |t|
      t.integer :tutor_profile_id
      t.string :teaching_subject

      t.timestamps
    end
  end
end
