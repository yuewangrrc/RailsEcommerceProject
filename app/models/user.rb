class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :orders, dependent: :destroy
  belongs_to :province, optional: true

  # Validations
  validates :name, presence: true, length: { minimum: 2 }

  def has_address?
    street_address.present? && city.present? && postal_code.present? && province.present?
  end

  def full_address
    return nil unless has_address?
    "#{street_address}, #{city}, #{province.name} #{postal_code}"
  end
end
