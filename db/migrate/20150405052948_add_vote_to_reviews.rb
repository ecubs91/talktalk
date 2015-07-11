class AddVoteToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :vote, :boolean#, null: false
  end
end
