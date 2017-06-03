class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.integer :level
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
