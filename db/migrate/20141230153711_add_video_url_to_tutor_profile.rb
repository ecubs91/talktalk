class AddVideoUrlToTutorProfile < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :video_url, :text
  end
end
