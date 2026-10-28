class EtpProgram < ApplicationRecord
  belongs_to :unit
  has_many :etp_sessions, dependent: :destroy

  PATHOLOGY_LABELS = {
    "bipolar"         => "Trouble bipolaire",
    "depression"      => "Dépression",
    "schizophrenia"   => "Schizophrénie",
    "addiction"       => "Addictions",
    "anxiety"         => "Troubles anxieux",
    "eating_disorder" => "Troubles du comportement alimentaire"
  }.freeze

  MODALITY_LABELS = {
    "individual" => "Individuel",
    "group"      => "En groupe",
    "mixed"      => "Individuel et en groupe"
  }.freeze

  PATHOLOGIES = PATHOLOGY_LABELS.keys.freeze
  MODALITIES = MODALITY_LABELS.keys.freeze

  validates :name, presence: true
  validates :pathology, presence: true, inclusion: { in: PATHOLOGIES }
  validates :modality, presence: true, inclusion: { in: MODALITIES }
  validates :prerequisites, presence: true

  def pathology_label
    PATHOLOGY_LABELS[pathology]
  end

  def modality_label
    MODALITY_LABELS[modality]
  end
end
