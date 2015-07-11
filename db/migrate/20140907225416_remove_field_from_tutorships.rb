class RemoveFieldFromTutorships < ActiveRecord::Migration
  def change
    remove_column :tutorships, :tutorship_profile_id, :integer
  end
end
