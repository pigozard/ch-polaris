class Schedule < ApplicationRecord
  belongs_to :unit

  SCHEDULE_TYPES = %w[consultation visiting phone].freeze

  validates :schedule_type, presence: true, inclusion: { in: SCHEDULE_TYPES }
end
