class Pole < ApplicationRecord
  has_many :units, dependent: :destroy
  has_many :news, dependent: :nullify

  COLORS = %w[#3B82F6 #8B5CF6 #F97316 #22C55E #94A3B8].freeze

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :color, presence: true

  before_validation :generate_slug

  scope :ordered, -> { order(:position) }

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end
end
