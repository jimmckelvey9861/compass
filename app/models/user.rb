class User < ApplicationRecord
  # Validations
  validates :email, presence: true
  validates :full_name, presence: true

  # Add any associations here if needed
  # belongs_to :organization
end