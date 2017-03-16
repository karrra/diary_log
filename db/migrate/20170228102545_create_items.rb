class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :bill_id
      t.integer :item_type
      t.string :memo
      t.decimal :amount, precision: 6, scale: 1, default: 0.0

      t.timestamps null: false
    end
  end
end
