FactoryGirl.define do
  factory :package do
    server
    pkgtype 'RPM'
    sequence (:name) {|n| "testPackage#{n}"}
    pkgversion '1.0'
    architecture 'i386'
  end
end
