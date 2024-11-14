class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.text :description
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.integer :level, null: false, default: 0  # For enum
      t.string :language, limit: 50
      t.column :duration, :interval

      t.timestamps
    end
  end
end
