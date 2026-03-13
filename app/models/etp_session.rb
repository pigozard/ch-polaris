class EtpSession < ApplicationRecord
  belongs_to :etp_program

  SESSION_TYPES = %w[recurring punctual].freeze
  STATUSES = %w[open full cancelled].freeze

  validates :session_type, presence: true, inclusion: { in: SESSION_TYPES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :recurrence, presence: true, if: -> { session_type == 'recurring' }
  validates :starts_on, presence: true, if: -> { session_type == 'punctual' }
end
