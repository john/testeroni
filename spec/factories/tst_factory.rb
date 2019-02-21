FactoryBot.define do

  factory :tst do
    name {'Donkies'}
    description {'Kind of like horses'}
    user {create :user}
  end

end
