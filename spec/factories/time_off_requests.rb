FactoryBot.define do
  factory :time_off_request do
    user_id { 1 }
    start_date { "2025-06-29" }
    end_date { "2025-06-29" }
    reason { "MyString" }
    status { "MyString" }
    approved_by_id { 1 }
    notes { "MyText" }
  end
end
