class Timesheet < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :shift

  # Validations can be added here as needed
end