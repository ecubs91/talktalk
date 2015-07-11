class AddHoursToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :hours, :integer
  end
end
