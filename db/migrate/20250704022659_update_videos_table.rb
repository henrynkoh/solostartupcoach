class UpdateVideosTable < ActiveRecord::Migration[7.2]
  def change
    # Remove old columns
    remove_reference :videos, :startup_tip, foreign_key: true
    remove_column :videos, :script
    remove_column :videos, :video_path
    remove_column :videos, :thumbnail_path
    remove_column :videos, :youtube_id

    # Add new columns
    add_column :videos, :title, :string, null: false
    add_column :videos, :description, :text, null: false
    add_column :videos, :file_path, :string, null: false
    add_column :videos, :file_size, :bigint, null: false
    add_column :videos, :duration, :integer
    add_column :videos, :youtube_url, :string

    # Add indices
    add_index :videos, :title
    add_index :videos, :youtube_url, unique: true, where: 'youtube_url IS NOT NULL'
  end
end
