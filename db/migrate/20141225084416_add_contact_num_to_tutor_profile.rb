class AddContactNumToTutorProfile < ActiveRecord::Migration
  def change
    add_column :tutor_profiles, :contact_num, :string
  end
end
