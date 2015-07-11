class AddLocationCityToTutorProfile < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :location_city, :string
  end
end
