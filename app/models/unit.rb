class Unit < ApplicationRecord
  belongs_to :pole
  has_many :schedules, dependent: :destroy
  has_many :sectors, dependent: :destroy
  has_one :unit_regulation, dependent: :destroy
  has_many :etp_programs, dependent: :destroy

UNIT_TYPES = %w[
  ward_open
  ward_closed
  cmp
  hdj
  cattp
  sessad
  empp
  mobile_team
  ulpsy
  cump
  expert_center
  utep
  users_house
  long_stay
  csapa
  mas
  camsp
  crisis_unit
  perinatal
].freeze

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :unit_type, presence: true, inclusion: { in: UNIT_TYPES }

  before_validation :generate_slug

  scope :ordered, -> { order(:position) }
  scope :by_type, ->(type) { where(unit_type: type) }

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end
end
