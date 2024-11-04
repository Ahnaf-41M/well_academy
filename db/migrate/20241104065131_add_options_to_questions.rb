class AddOptionsToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :options, :jsonb, default: [], null: false
  end
end
