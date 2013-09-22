class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :money
      t.references :User, index: true
      t.references :Charity, index: true

      t.timestamps
    end
  end
end
