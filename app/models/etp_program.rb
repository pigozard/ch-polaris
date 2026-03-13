class EtpProgram < ApplicationRecord
  belongs_to :unit
  has_many :etp_sessions, dependent: :destroy

  PATHOLOGIES = %w[bipolar depression schizophrenia addiction anxiety eating_disorder].freeze
  MODALITIES = %w[individual group mixed].freeze

  validates :name, presence: true
  validates :pathology, presence: true, inclusion: { in: PATHOLOGIES }
  validates :modality, presence: true, inclusion: { in: MODALITIES }
  validates :prerequisites, presence: true
end
