class CreateVideoWatches < ActiveRecord::Migration[7.2]
  def change
    create_table :video_watches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.datetime :watched_at

      t.timestamps
    end
  end
end
