class AddLessonsCountToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :lessons_count, :integer, default: 0, null: false
  end
end
