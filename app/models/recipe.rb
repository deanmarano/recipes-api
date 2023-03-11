class Recipe < ApplicationRecord
  include AASM
  validates :url, uniqueness: true

  belongs_to :user
  has_one :page_snapshot
  before_save :set_slug

  aasm column: :status do
    state :draft, initial: true
    state :active
    state :archived

    event :archive do
      transitions from: [:draft, :active], to: :archived
    end


    event :publish do
      transitions from: :draft, to: :active
    end
  end

  has_many_attached :images

  private

  def set_slug
    if slug.blank?
      url = URI.parse(self.source)
      self.slug = url.path.gsub(/^\/?/, "").gsub(/\/$/, '') ||
        source.gsub(/.*\//, '') || source.gsub(/.*\//, '')
    end
  end
end
