class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :phone, limit: 20
      t.timestamp :date_joined, default: -> { 'CURRENT_TIMESTAMP' }
      t.text :bio
      t.integer :role, default: 0

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true

  end
end
