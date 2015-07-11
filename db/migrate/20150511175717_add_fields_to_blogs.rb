class AddFieldsToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :user_id, :integer
    add_column :blogs, :education, :string
  end
end
