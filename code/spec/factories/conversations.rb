FactoryBot.define do
  factory :conversation do
    association :created_by, factory: :user
  end
end
