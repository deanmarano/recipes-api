class Recipe < ApplicationRecord
  include AASM

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
