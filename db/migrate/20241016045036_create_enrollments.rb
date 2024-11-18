class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.belongs_to :student, foreign_key: { to_table: :users }, null: false
      t.belongs_to :course, foreign_key: true, null: false
      t.timestamp :enrolled_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.decimal :progress, precision: 10, scale: 2, default: 0.0
      t.integer :completion_status, null: false, default: 0 # For enum

      t.timestamps
    end
  end
end
