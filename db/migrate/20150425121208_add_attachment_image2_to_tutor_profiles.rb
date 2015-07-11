class AddAttachmentImage2ToTutorProfiles < ActiveRecord::Migration
  def self.up
    change_table :tutor_profiles do |t|
      t.attachment :image2
    end
  end

  def self.down
    drop_attached_file :tutor_profiles, :image2
  end
end
