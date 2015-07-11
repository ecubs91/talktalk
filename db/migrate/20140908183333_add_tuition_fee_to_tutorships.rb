class AddTuitionFeeToTutorships < ActiveRecord::Migration
  def change
    add_column :tutorships, :tuition_fee, :decimal, precision: 5, scale: 2
  end
end
