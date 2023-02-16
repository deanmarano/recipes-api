class Recipe < ApplicationRecord
  include AASM
  validates :url, uniqueness: true

  belongs_to :user

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
end
