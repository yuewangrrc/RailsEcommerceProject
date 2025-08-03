class Category < ApplicationRecord
  # Associations
  has_many :products, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
end
