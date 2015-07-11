class CreateTeachingSubjectLevels < ActiveRecord::Migration
  def change
    create_table :teaching_subject_levels do |t|
      t.integer :tutor_teaching_subject_id
      t.string :level

      t.timestamps
    end
  end
end
