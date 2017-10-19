class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.integer :user_id
      t.string :action
      t.string :ip_address
      t.text   :detail

      t.timestamps null: false
    end
  end
end
