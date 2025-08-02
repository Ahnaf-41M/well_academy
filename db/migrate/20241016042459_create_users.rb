class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone, limit: 20
      t.text :bio
      t.integer :role, default: 0
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
