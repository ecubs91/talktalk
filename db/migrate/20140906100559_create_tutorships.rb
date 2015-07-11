class CreateTutorships < ActiveRecord::Migration
  def change
    create_table :tutorships do |t|
      t.integer :tutor_id
      t.integer :student_id
      t.integer :subject_id
      t.boolean :accepted
      t.string :starting_date
      t.string :duration

      t.timestamps
    end
  end
end
