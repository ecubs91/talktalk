class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.text :content
      t.integer :category_id

      t.timestamps
    end
  end
end
