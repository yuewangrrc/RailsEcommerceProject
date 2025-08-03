class Product < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many_attached :images

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
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND updated_at != created_at', 1.day.ago) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :search_by_text, ->(query) { where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") if query.present? }

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

  def new_product?
    created_at >= 3.days.ago
  end

  def recently_updated?
    updated_at >= 3.days.ago && created_at < 3.days.ago
  end

  def current_price
    on_sale? && sale_price.present? ? sale_price : price
  end

  def discount_percentage
    return 0 unless on_sale? && sale_price.present? && price > sale_price
    ((price - sale_price) / price * 100).round
  end

  # Image methods
  def primary_image
    images.attached? ? images.first : nil
  end

  def image_url_or_placeholder
    if primary_image.present?
      Rails.application.routes.url_helpers.rails_blob_url(primary_image, only_path: true)
    else
      'https://via.placeholder.com/300x300?text=No+Image'
    end
  end
end
