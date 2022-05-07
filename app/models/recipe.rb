class Recipe < ApplicationRecord
  include AASM
  validates :url, uniqueness: true

  aasm column: :status do
    state :draft, initial: true
    state :active
    state :archived

    event :archive do
      transitions from: [:draft, :active], to: :archived
    end
  end

  has_many_attached :images
end
