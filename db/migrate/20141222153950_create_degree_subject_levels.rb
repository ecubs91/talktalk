class CreateDegreeSubjectLevels < ActiveRecord::Migration
  def change
    create_table :degree_subject_levels do |t|
      t.integer :tutor_degree_subject_id
      t.string :level

      t.timestamps
    end
  end
end
