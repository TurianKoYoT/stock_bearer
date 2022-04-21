FactoryBot.define do
  factory :bearer do
    sequence :name do |n|
      "Bearer #{n}"
    end
  end
end
