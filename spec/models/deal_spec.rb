require 'rails_helper'

RSpec.describe Deal, type: :model do
  it {should validate_inclusion_of(:status).in_array(Deal::STATUSES) }
end
