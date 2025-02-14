class CreateQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :quizzes do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :total_marks, null: false

      t.timestamps
    end
  end
end
