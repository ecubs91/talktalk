class AddPricesToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :hourly_rate, :decimal, precision: 5, scale: 2
    add_column :tutorships, :hours_a_week, :decimal, precision: 3, scale: 1
    add_column :tutorships, :weeks, :integer
  end
end
