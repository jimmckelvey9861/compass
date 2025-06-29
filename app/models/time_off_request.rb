class TimeOffRequest < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }
  
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
