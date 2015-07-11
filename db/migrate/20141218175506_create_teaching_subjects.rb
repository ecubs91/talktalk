class CreateTeachingSubjects < ActiveRecord::Migration
  def change
    create_table :teaching_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
