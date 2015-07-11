class CreateDegreeSubjects < ActiveRecord::Migration
  def change
    create_table :degree_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
