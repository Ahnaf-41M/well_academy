class CreateQuizParticipations < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_participations do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :quiz, null: false, foreign_key: true
      t.integer :marks_obtained, null: false
      t.integer :total_marks, null: false
      t.timestamp :submitted_at

      t.timestamps
    end
  end
end
