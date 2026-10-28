class EtpSession < ApplicationRecord
  belongs_to :etp_program

  SESSION_TYPES = %w[recurring punctual].freeze
  STATUS_LABELS = {
    "open"      => "Ouvert",
    "full"      => "Complet",
    "cancelled" => "Annulé"
  }.freeze
  STATUSES = STATUS_LABELS.keys.freeze

  validates :session_type, presence: true, inclusion: { in: SESSION_TYPES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :recurrence, presence: true, if: -> { session_type == 'recurring' }
  validates :starts_on, presence: true, if: -> { session_type == 'punctual' }

  def status_label
    STATUS_LABELS[status]
  end

  def remaining_places
    return if max_participants.nil?

    [max_participants - current_participants.to_i, 0].max
  end
end
