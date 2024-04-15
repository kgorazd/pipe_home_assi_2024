FactoryBot.define do
  factory :deal, class: Deal do
    sequence(:name) { |i| "Deal #{i}" }
    status { Deal::STATUSES.sample }
    amount { rand(10..1000) }
    company_id { create(:company).id }
  end
end
