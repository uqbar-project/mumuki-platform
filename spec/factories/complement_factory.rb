FactoryGirl.define do

  factory :complement, traits: [:guide_container] do
    unit { Organization.current.first_unit }
  end
end
