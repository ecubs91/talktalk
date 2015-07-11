class AddAchievementToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :achievement, :string
  end
end
