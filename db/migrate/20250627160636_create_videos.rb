class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :startup_tip, null: false, foreign_key: true
      t.string :script, null: false, limit: 2048
      t.string :video_path
      t.string :thumbnail_path
      t.string :youtube_id, null: true
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :videos, :youtube_id, unique: true, where: 'youtube_id IS NOT NULL'
  end
end
