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

  UNIT_TYPE_LABELS = {
    "ward_open"     => "Hospitalisation ouverte",
    "ward_closed"   => "Hospitalisation fermée",
    "cmp"           => "Centre Médico-Psychologique",
    "hdj"           => "Hôpital de jour",
    "cattp"         => "CATTP",
    "sessad"        => "SESSAD",
    "empp"          => "Équipe mobile précarité",
    "mobile_team"   => "Équipe mobile",
    "ulpsy"         => "Unité de liaison psychiatrique",
    "cump"          => "Cellule d'urgence médico-psychologique",
    "expert_center" => "Centre expert",
    "utep"          => "Unité transversale ETP",
    "users_house"   => "Maison des usagers",
    "long_stay"     => "Séjour longue durée",
    "csapa"         => "CSAPA",
    "mas"           => "Maison d'accueil spécialisée",
    "camsp"         => "CAMSP",
    "crisis_unit"   => "Unité de crise",
    "perinatal"     => "Unité périnatale"
  }.freeze

  def self.type_label(type)
    UNIT_TYPE_LABELS.fetch(type, type)
  end

  def to_annuaire_json(pole)
    {
      id:          id,
      name:        name,
      slug:        slug,
      type:        unit_type,
      type_label:  Unit.type_label(unit_type),
      phone:       phone,
      email:       email,
      pmr:         pmr_accessible,
      address:     address,
      parking:     parking_info,
      description: description,
      pole_slug:   pole.slug,
      pole_name:   pole.name,
      pole_color:  pole.color,
      schedules:   schedules.map { |s|
        {
          type:      s.schedule_type,
          opens_at:  s.opens_at&.strftime("%H:%M"),
          closes_at: s.closes_at&.strftime("%H:%M"),
          note:      s.note
        }
      },
      sectors:     sectors.map { |s| { postal_code: s.postal_code, city: s.city } },
      regulation:  unit_regulation ? {
        max_visitors:    unit_regulation.max_visitors,
        allowed_items:   unit_regulation.allowed_items,
        forbidden_items: unit_regulation.forbidden_items,
        visiting_notes:  unit_regulation.visiting_notes,
        access_info:     unit_regulation.access_info
      } : nil
    }
  end

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
