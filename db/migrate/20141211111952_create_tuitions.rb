class CreateTuitions < ActiveRecord::Migration
  def change
    create_table :tuitions do |t|
      t.integer :hours
      t.string :city
      t.text :note
      t.integer :user_id
      t.integer :tutor_profile_id

      t.timestamps
    end
  end
end
