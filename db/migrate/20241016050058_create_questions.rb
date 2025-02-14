class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :marks, null: false
      t.column :options, :jsonb, default: [], null: false

      t.timestamps
    end
  end
end
