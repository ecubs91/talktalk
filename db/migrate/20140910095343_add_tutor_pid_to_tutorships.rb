class AddTutorPidToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :tutor_profile_id, :integer
  end
end
