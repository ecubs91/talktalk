class AddHourlyRateToTutorProfiles < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :hourly_rate, :decimal, :default => 25
  end
end
