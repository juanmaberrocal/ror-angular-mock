require 'spec_helper'

# user specs
RSpec.describe User, type: :model do

	# builder
	describe 'Builder' do
		it 'Valid Factory' do
			FactoryGirl.build(:user).should be_valid
		end
	end

	# validations
	describe 'Validations' do
		it 'Presence Email' do
			# requires email
			FactoryGirl.build(:user, email: nil).should_not be_valid
		end

		it 'Presence Password' do
			# requires password
			FactoryGirl.build(:user, password: nil).should_not be_valid
		end

		it 'Presence Username' do
			# requires username
			FactoryGirl.build(:user, username: nil).should_not be_valid
		end

		it 'Unique Email' do
			# requires unique emails
			FactoryGirl.create(:user, email: 'rspec@email.com')
			FactoryGirl.build(:user, email: 'rspec@email.com').should_not be_valid
		end
	end

	# relations
	describe 'Relations' do
		it 'Has many Tickets' do
			# build user and ticket associated to record
			user = FactoryGirl.create(:user)
			FactoryGirl.create(:ticket, user: user)

			user.tickets.first.class.should == Ticket
		end
	end

end