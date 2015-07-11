class AddTutorProfileIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :tutor_profile_id, :integer
  end
end
