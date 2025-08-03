class AddAddressToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :street_address, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
    add_reference :users, :province, null: true, foreign_key: true
  end
end
