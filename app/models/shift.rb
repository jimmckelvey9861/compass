class Shift < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :assigned_user, class_name: 'User', optional: true
  belongs_to :job, optional: true

  # Validations
  validate :job_belongs_to_organization, if: :job_id?

  private

  def job_belongs_to_organization
    if job.present? && job.organization_id != organization_id
      errors.add(:job, "must belong to the same organization as the shift")
    end
  end
end