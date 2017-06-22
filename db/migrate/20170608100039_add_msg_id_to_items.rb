class AddMsgIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :msg_id, :string
  end
end
