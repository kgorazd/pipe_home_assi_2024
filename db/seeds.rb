# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

30.times do |i|
  Company.create!(
    name: Faker::Company.name,
    industry: Faker::Company.industry,
    employee_count: rand(10..1000)
  )
end

90.times do |i|
  Deal.create!(
    name: "Deal #{i}",
    status: Deal::STATUSES.sample,
    amount: rand(10..1000),
    company_id: Company.order("RAND()").first.id
  )
end

User.create!(login: 'user', password: '123', api_token: 'abc123')
