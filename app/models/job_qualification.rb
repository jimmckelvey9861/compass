class JobQualification < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :user_id, presence: true
  validates :job_id, presence: true
  validates :user_id, uniqueness: { scope: :job_id, message: "already has a qualification for this job" }
  
  validate :certified_date_presence_when_certified

  private

  def certified_date_presence_when_certified
    if certified? && certified_date.blank?
      errors.add(:certified_date, "must be present when certified is true")
    end
  end
end