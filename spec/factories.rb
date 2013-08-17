FactoryGirl.define do
  factory :user do
    name     "Iiro Vaahtojärvi"
    email    "iirovaahtojarvi@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end