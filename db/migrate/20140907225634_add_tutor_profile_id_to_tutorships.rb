class AddTutorProfileIdToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :tutor_profile_id, :string
  end
end
