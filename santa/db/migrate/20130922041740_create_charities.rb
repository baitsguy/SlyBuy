class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.integer :phone
      t.string :email, limit: 40
      t.string :wishlist
      t.integer :donations

      t.timestamps
    end
    add_index :charities, :name, unique: true
  end
end
