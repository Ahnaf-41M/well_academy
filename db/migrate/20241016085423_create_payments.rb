class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.decimal :course_price, precision: 10, scale: 2, null: false
      t.integer :payment_type, null: false, default: 0 # 0 for bkash, 1 for bank, etc.
      t.integer :status, null: false, default: 0 # 0 for unpaid, 1 for paid

      t.timestamps
    end
  end
end
