class Deal < ApplicationRecord
  belongs_to :company

  STATUSES = %w[pending won lost].freeze

  validates :status, inclusion: { in: STATUSES }
end
