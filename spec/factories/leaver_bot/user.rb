FactoryBot.define do
  factory :user, class: 'LeaverBot::User' do
    first_name 'John'
    last_name  'Doe'
    username 'johndoe'
  end
end
