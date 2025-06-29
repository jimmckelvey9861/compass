class Shift < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :assigned_user, class_name: 'User', optional: true

  # Validations can be added here as needed
end