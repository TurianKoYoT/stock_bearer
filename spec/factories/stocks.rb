FactoryBot.define do
  factory :stock do
    sequence :name do |n|
      "Stock #{n}"
    end

    bearer
  end
end
