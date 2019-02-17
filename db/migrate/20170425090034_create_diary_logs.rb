class CreateDiaryLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :diary_logs do |t|
      t.integer :user_id
      t.text :content

      t.timestamps null: false
    end
  end
end
