class Organization < ApplicationRecord
  # Validations
  validates :name, presence: true

  # Add any associations here if needed
  # has_many :users
end