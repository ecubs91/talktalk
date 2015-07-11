class RemoveDurationFromTutorships < ActiveRecord::Migration
  def change
    remove_column :tutorships, :duration, :string
  end
end
