class AddLocationTwoToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :location_two, :string
    add_column :tutor_profiles, :country, :string
  end
end
