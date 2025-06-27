class CreateStartupTips < ActiveRecord::Migration[7.2]
  def change
    create_table :startup_tips do |t|
      t.string :topic
      t.string :tool
      t.text :strategy
      t.text :case_study
      t.string :sentiment
      t.string :source_url

      t.timestamps
    end
    add_index :startup_tips, :topic
  end
end
