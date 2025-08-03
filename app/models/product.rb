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

  # Scopes for admin filtering
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :in_stock, -> { where('stock > 0') }
  scope :out_of_stock, -> { where(stock: 0) }
  scope :low_stock, -> { where('stock > 0 AND stock <= 5') }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :search_by_text, ->(query) { where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }

  # Instance methods
  def in_stock?
    stock > 0
  end

  def low_stock?
    stock > 0 && stock <= 5
  end

  def stock_status
    return 'Out of Stock' if stock == 0
    return 'Low Stock' if low_stock?
    'In Stock'
  end

  def stock_status_class
    return 'danger' if stock == 0
    return 'warning' if low_stock?
    'success'
  end
end
