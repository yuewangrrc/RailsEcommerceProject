class Province < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_tax_rate
    hst_rate > 0 ? hst_rate : (gst_rate + pst_rate)
  end
end
