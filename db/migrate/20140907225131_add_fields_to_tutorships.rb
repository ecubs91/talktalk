class AddFieldsToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :tutorship_profile_id, :integer
    add_column :tutorships, :user_id, :integer
  end
end
