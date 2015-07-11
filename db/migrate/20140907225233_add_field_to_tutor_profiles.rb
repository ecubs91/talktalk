class AddFieldToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :tutorship_id, :integer
  end
end
