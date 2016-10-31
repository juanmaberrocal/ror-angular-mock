FactoryGirl.define  do
	factory :ticket do
		title 'Test Ticket'
		category 'Bug'
		status 'Open'
		description 'Factory Test Ticket'
		# set associated user
		association :user, factory: :user
	end
	
end