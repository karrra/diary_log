class ChangeItemsColumns < ActiveRecord::Migration
  def change
    add_column :items, :parent_type_id, :integer
    add_column :items, :parent_type_name, :string
    add_column :items, :child_type_id, :integer
    add_column :items, :child_type_name, :string
    add_column :items, :record_at, :datetime
    add_column :items, :inorout, :integer
  end
end
