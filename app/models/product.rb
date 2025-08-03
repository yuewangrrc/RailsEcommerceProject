class Product < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :order_items, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 2 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :size, presence: true
end
