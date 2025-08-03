class Order < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  # Validations
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending processing shipped delivered cancelled] }

  # Instance methods for backward compatibility and convenience
  def total
    total_price
  end

  def calculate_totals
    self.subtotal = order_items.sum { |item| item.quantity * item.price }
    self.tax = (subtotal * (province&.total_tax_rate || 0)).round(2)
    self.total_price = subtotal + tax
  end

  def has_shipping_info?
    shipping_name.present? && shipping_address.present? && 
    shipping_city.present? && shipping_postal_code.present?
  end
end
