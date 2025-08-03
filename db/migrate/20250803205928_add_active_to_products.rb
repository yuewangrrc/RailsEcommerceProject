class AddActiveToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :active, :boolean, default: true, null: false
  end
end
