class Position < ApplicationRecord
  validates :company_name, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  
  serialize :requirements, Array
  serialize :identity_fields_required, Array
  serialize :video_questions, Array
  
  before_validation :ensure_arrays
  
  private
  
  def ensure_arrays
    self.requirements ||= []
    self.identity_fields_required ||= []
    self.video_questions ||= []
  end
end