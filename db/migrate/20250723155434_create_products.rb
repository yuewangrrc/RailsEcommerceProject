class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.string :size
      t.integer :stock
      t.string :image_url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
