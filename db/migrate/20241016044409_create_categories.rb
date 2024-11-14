class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, limit: 100, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
