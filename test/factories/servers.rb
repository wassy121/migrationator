FactoryGirl.define do
  sequence :ip_address do |n|
    "192.168.1.#{n}"
  end

  factory :server do
    user
    ip { Factory.next(:ip_address) }
    sequence (:name) {|n| "test_server#{n}"}
  end
end
