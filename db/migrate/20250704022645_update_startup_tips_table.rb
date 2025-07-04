class UpdateStartupTipsTable < ActiveRecord::Migration[7.2]
  def change
    # Remove old columns
    remove_column :startup_tips, :topic
    remove_column :startup_tips, :tool
    remove_column :startup_tips, :strategy
    remove_column :startup_tips, :case_study
    remove_column :startup_tips, :sentiment

    # Add new columns
    add_column :startup_tips, :title, :string, null: false
    add_column :startup_tips, :content, :text, null: false
    add_column :startup_tips, :sentiment_score, :decimal, precision: 3, scale: 2

    # Add indices
    add_index :startup_tips, :title
  end
end
