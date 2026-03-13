class News < ApplicationRecord
  belongs_to :pole, optional: true
  has_rich_text :content
  has_one_attached :cover_image

  CATEGORIES = %w[event announcement health_day institutional].freeze

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  before_validation :generate_slug

  scope :published, -> { where(published: true).order(published_at: :desc) }
  scope :recent, -> { published.limit(3) }

  private

  def generate_slug
    self.slug ||= title&.parameterize
  end
end
