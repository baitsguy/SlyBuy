class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.string :asin
      t.integer :date
      t.references :User, index: true

      t.timestamps
    end
    add_index :orders, :order_id
  end
end
