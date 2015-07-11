class AddFieldsToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :detailed_location, :string
    add_column :tutor_profiles, :contact_details, :text
  end
end
