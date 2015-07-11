class CreateTutorDegreeSubjects < ActiveRecord::Migration
  def change
    create_table :tutor_degree_subjects do |t|
      t.integer :tutor_profile_id
      t.string :degree_subject

      t.timestamps
    end
  end
end
