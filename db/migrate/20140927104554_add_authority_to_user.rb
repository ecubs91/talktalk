class AddAuthorityToUser < ActiveRecord::Migration
  def change
    add_column :users, :authority, :string
  end
end
