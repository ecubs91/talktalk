class AddAttachmentImageToTutorProfiles < ActiveRecord::Migration
  def self.up
    change_table :tutor_profiles do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :tutor_profiles, :image
  end
end
