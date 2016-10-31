FactoryGirl.define  do

	factory :user do
		sequence(:username){ |n| "user#{n}" }
		sequence(:email){ |n| "user#{n}@testers.com" }
		password 'password'
		admin false
	end
	
end