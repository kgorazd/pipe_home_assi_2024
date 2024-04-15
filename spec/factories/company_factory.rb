FactoryBot.define do
  factory :company, class: Company do
    name { Faker::Company.name }
    industry { Faker::Company.industry }
    employee_count { rand(10..1000) }
  end
end
