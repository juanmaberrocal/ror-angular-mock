require 'spec_helper'

# user specs
RSpec.describe Ticket, type: :model do

	# builder
	describe 'Builder' do
		it 'Valid Factory' do
			FactoryGirl.build(:ticket).should be_valid
		end
	end

	# validations
	describe 'Validations' do
		it 'Presence Title' do
			# requires title
			FactoryGirl.build(:ticket, title: nil).should_not be_valid
		end

		it 'Presence User' do
			# requires user
			FactoryGirl.build(:ticket, user: nil).should_not be_valid
		end

		it 'Inclusion Category' do
			# requires category in list
			FactoryGirl.build(:ticket, category: 'Bug').should be_valid

			# ensure invalid on nil or value outside of list
			FactoryGirl.build(:ticket, category: nil).should_not be_valid
			FactoryGirl.build(:ticket, category: 'Test Category').should_not be_valid
		end

		it 'Inclusion Status' do
			# requires status in list
			FactoryGirl.build(:ticket, status: 'Open').should be_valid

			# ensure invalid on nil or value outside of list
			FactoryGirl.build(:ticket, status: nil).should_not be_valid
			FactoryGirl.build(:ticket, status: 'Test Status').should_not be_valid
		end
	end

	# relations
	describe 'Relations' do
		it 'Belongs to User' do
			FactoryGirl.build(:ticket).user.class.should == User
		end

		it 'Belongs to User Closer' do
			FactoryGirl.build(:ticket, user_closer: FactoryGirl.build(:user)).user_closer.class.should == User
		end
	end

	# methods
	describe 'Methods' do
		it 'Method .owner' do
			FactoryGirl.build(:ticket).owner.should_not == 'Ticket has no owner!'

			# ensure if no owner expect rescue message
			FactoryGirl.build(:ticket, user_id: nil).owner.should == 'Ticket has no owner!'
		end

		it 'Method .closer' do
			FactoryGirl.build(:ticket, status: 'Closed', user_closer: FactoryGirl.build(:user)).closer.should_not == 'Ticket has not been closed!'
			FactoryGirl.build(:ticket, status: 'Closed', user_closer: FactoryGirl.build(:user)).closer.should_not == 'Ticket has no closer!'

			# ensure if no closer expect rescue message
			FactoryGirl.build(:ticket, status: 'Closed').closer.should == 'Ticket has no closer!'

			# ensure if status !closed expect rescue message
			FactoryGirl.build(:ticket).closer.should == 'Ticket has not been closed!'
		end
	end

end