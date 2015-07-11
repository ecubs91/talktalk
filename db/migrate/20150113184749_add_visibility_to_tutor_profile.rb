class AddVisibilityToTutorProfile < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :visibility, :boolean, :default => false
  end
end
