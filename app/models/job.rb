class Job < ApplicationRecord
  belongs_to :organization

  AVAILABLE_LANGUAGES = [
    'English',
    'Spanish',
    'Mandarin',
    'French',
    'Arabic',
    'Portuguese',
    'Russian',
    'Vietnamese',
    'Korean',
    'Japanese'
  ].freeze

  COLOR_PALETTE = [
    '#3B82F6', # blue-500
    '#10B981', # emerald-500
    '#F59E0B', # amber-500
    '#EF4444', # red-500
    '#8B5CF6', # purple-500
    '#EC4899', # pink-500
    '#06B6D4', # cyan-500
    '#6366F1', # indigo-500
    '#84CC16', # lime-500
    '#F97316', # orange-500
    '#14B8A6', # teal-500
    '#A855F7'  # violet-500
  ].freeze

  serialize :required_languages, Array

  validates :name, presence: true
  validates :organization_id, presence: true
  validates :pay_rate, presence: true, numericality: { greater_than: 0 }
  validates :pay_type, inclusion: { in: %w[hourly salary] }
  validates :status, inclusion: { in: %w[active inactive deleted] }
  validate :required_languages_must_be_valid

  private

  def required_languages_must_be_valid
    return if required_languages.blank?

    invalid_languages = required_languages - AVAILABLE_LANGUAGES
    if invalid_languages.any?
      errors.add(:required_languages, "contains invalid languages: #{invalid_languages.join(', ')}")
    end
  end
end