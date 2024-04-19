# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :deals

  scope :with_total_deal_amount, lambda {
                                   left_joins(:deals).select('companies.*, IFNULL(sum(deals.amount), 0) as total_deal_amount').group('companies.id')
                                 }

  def calculate_total_deal_amount
    deals.sum(:amount)
  end
end
