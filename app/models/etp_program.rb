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
  validate :recruitment_months_are_valid

  # « janvier, avril et septembre »
  def recruitment_months_label
    recruitment_months.sort.map { |month| I18n.t("date.month_names")[month] }.to_sentence
  end

  # Premier jour du prochain mois de recrutement (le mois en cours compte), nil si aucun mois
  def next_recruitment(today = Date.current)
    return if recruitment_months.empty?

    month = recruitment_months.sort.find { |m| m >= today.month }
    month ? Date.new(today.year, month, 1) : Date.new(today.year + 1, recruitment_months.min, 1)
  end

  def pathology_label
    PATHOLOGY_LABELS[pathology]
  end

  def modality_label
    MODALITY_LABELS[modality]
  end

  private

  def recruitment_months_are_valid
    return if recruitment_months.all? { |m| (1..12).cover?(m) }

    errors.add(:recruitment_months, :inclusion)
  end
end
