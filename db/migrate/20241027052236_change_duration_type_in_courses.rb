class ChangeDurationTypeInCourses < ActiveRecord::Migration[6.0]
  def up
    change_column :courses, :duration, :interval
  end

  def down
    change_column :courses, :duration, :integer
  end
end
