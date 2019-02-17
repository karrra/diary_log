class AddMsgIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :msg_id, :string
  end
end
