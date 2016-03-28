FactoryGirl.define do
  factory :movie do
    sequence(:title) { |n| "Jaws #{n}"}
    sequence(:description) { |n| "Who\'s scruffy-looking? #{n}" }
    sequence(:date) { |n| '1980-05-2#{n}' }
    sequence(:user_id) { |n| user}
  end
end
