class RemoveVideoUrlFromTutorProfile < ActiveRecord::Migration
  def change
    remove_column :tutor_profiles, :video_url
  end
end
