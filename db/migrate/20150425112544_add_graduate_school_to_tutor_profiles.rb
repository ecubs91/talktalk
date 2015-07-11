class AddGraduateSchoolToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :graduate_school, :text
  end
end
