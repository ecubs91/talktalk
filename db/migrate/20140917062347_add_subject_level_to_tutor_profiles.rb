class AddSubjectLevelToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :subject_level, :string
  end
end
