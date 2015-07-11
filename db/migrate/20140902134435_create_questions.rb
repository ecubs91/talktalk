class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :subject
      t.string :question
      t.text :text

      t.timestamps
    end
  end
end
