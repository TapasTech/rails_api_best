FactoryBot.define do
  factory :article do
    title { FFaker::Job.title }
    content { FFaker::HTMLIpsum.body }
    author { FFaker::Book.author }
    summary { FFaker::Book.description }
    visit_times { 3 }
  end
end
