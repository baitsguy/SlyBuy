class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.string :asin
      t.date :date
      t.references :user, index: true

      t.timestamps
    end
  end
end
