class ChangeDurationTypeInCourses < ActiveRecord::Migration[6.0]
  def up
    # Change the column type to interval with specific casting
    change_column :courses, :duration, :interval, using: 'duration * interval \'1 minute\''
  end

  def down
    change_column :courses, :duration, :integer
  end
end
