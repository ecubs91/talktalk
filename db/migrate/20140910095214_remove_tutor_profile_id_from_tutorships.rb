class RemoveTutorProfileIdFromTutorships < ActiveRecord::Migration
  def change
    remove_column :tutorships, :tutor_profile_id, :string
  end
end
