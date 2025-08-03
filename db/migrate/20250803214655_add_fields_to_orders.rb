class AddFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal, :decimal
    add_column :orders, :tax, :decimal
    add_column :orders, :shipping_name, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_postal_code, :string
    add_reference :orders, :province, null: true, foreign_key: true
    
    # Update existing orders to have a default province (Ontario)
    reversible do |dir|
      dir.up do
        default_province = Province.find_by(name: 'Ontario')
        if default_province
          Order.where(province_id: nil).update_all(province_id: default_province.id)
        end
      end
    end
  end
end
