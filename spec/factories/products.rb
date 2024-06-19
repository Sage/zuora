FactoryBot.define do
  factory :product, class: Zuora::Objects::Product do
    sequence(:name) { |n| "Example Product #{n}" }
    effective_start_date { DateTime.now }
    effective_end_date { DateTime.now + 10.days }
  end

  factory :product_catalog, parent: :product do
    after(:create) do |product|
      rate_plan = FactoryBot.create(:product_rate_plan, product: product)
      FactoryBot.create(:product_rate_plan_charge, product_rate_plan: rate_plan)
    end
  end
end
