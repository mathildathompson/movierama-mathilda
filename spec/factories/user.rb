FactoryGirl.define do
  factory :user do
    sequence(:uid) { |n| "null|1234#{n}"}
    sequence(:name) { |n| "Joe Bloggs #{n}" }
    sequence(:email) { |n| "joe#{n}@bloggs.com" }
  end
end
