class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Virtual attribute for authentication
  attr_accessor :login

  # Associations
  has_many :orders, dependent: :destroy
  belongs_to :province, optional: true

  # Validations
  validates :name, presence: true, length: { minimum: 2 }, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # Allow login with name instead of email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:name) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def has_address?
    street_address.present? && city.present? && postal_code.present? && province.present?
  end

  def full_address
    return nil unless has_address?
    "#{street_address}, #{city}, #{province.name} #{postal_code}"
  end

  # Admin functionality
  def admin?
    admin == true
  end
end
