FactoryBot.define do

  factory :user do
    name {"Abe Vigoda"}
    sequence(:email) { |n| "abraham#{n}@example.com" }
    password {'1234abcd'}
  end
end
