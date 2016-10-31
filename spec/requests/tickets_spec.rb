require 'spec_helper'

# ticket specs
RSpec.describe Api::V1::TicketsController, type: :controller do
	
	# ensure users can only reach correct requests
	describe "Ticket Actions for User" do 
		login_user

		# users can view tickets
		it 'index' do 
			# build fake tickets
			tickets = FactoryGirl.create_list(:ticket, rand(1..10))

			# call index
			get :index, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct amount of records returned
			expect(json.length).to eq(tickets.length)
		end

		# users can view specific tickets
		it 'show' do
			# create fake ticket
			ticket = FactoryGirl.create(:ticket)

			# call show
			get :show, id: ticket.id, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct data is returned
			# controller rebuilds response, so just ensure same record is returned
			expect(json["id"]).to eq(ticket.id)
		end

		# users can create new tickets
		it 'create' do
			# keep track of initial amount of tickets
			tickets_count = Ticket.all.count

			# init ticket
			ticket_attrs = FactoryGirl.attributes_for(:ticket, user_id: @user.id) # use curr user

			# call create
			post :create, ticket: ticket_attrs, format: :json

			# ensure user can create
			expect(response).to be_success

			# ensure correct data is returned
			# check if a ticket was created
			expect(Ticket.all.count).to eq(tickets_count+1)
			# check if a last ticket created is from current user
			expect(Ticket.all.last.user_id).to eq(@user.id)
		end

		# users can update tickets
		it 'update' do
			# create fake ticket to be updated
			ticket = FactoryGirl.create(:ticket)

			# set attributes to be updated
			ticket_attrs = ticket.as_json.merge!(category: 'Task', description: 'Updated by RSpec')

			# call update
			put :update, id: ticket.id, ticket: ticket_attrs, format: :json

			# ensure user can update
			expect(response).to be_success

			# ensure correct data is returned
			# updated record should have matching values for attr keys sent
			ticket.reload # record must be reloaded with change
			expect(ticket.category).to eq(ticket_attrs[:category])
			expect(ticket.description).to eq(ticket_attrs[:description])
		end

		# users cannot destroy tickets
		it 'destroy' do
			# create fake ticket to be destroyed
			ticket = FactoryGirl.create(:ticket)

			# get initial count of tickets
			tickets_count = Ticket.all.count

			# call destroy
			delete :destroy, id: ticket.id

			# ensure user cannot destroy
			expect(response).to_not be_success

			# ensure no records have be deleted
			expect(Ticket.all.count).to eq(tickets_count)
		end

		# users cannot close tickets
		it 'close' do
			# create fake ticket to be closed
			ticket = FactoryGirl.create(:ticket)

			# call close
			post :close, id: ticket.id

			# ensure user cannot close
			expect(response).to_not be_success

			# ensure ticket was not updated
			ticket.reload # record must be reloaded to ensure check for change
			expect(ticket.status).to eq('Open')
		end
	end

	# ensure admins have access to all request
	describe "Ticket Actions for Admins" do
		login_admin

		# admins can view tickets
		it 'index' do 
			# build fake tickets
			tickets = FactoryGirl.create_list(:ticket, rand(1..10))

			# call index
			get :index, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct amount of records returned
			expect(json.length).to eq(tickets.length)
		end

		# admins can view specific tickets
		it 'show' do
			# create fake ticket
			ticket = FactoryGirl.create(:ticket)

			# call show
			get :show, id: ticket.id, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct data is returned
			# controller rebuilds response, so just ensure same record is returned
			expect(json["id"]).to eq(ticket.id)
		end

		# admins can create new tickets
		it 'create' do
			# keep track of initial amount of tickets
			tickets_count = Ticket.all.count

			# init ticket
			ticket_attrs = FactoryGirl.attributes_for(:ticket, user_id: @user.id) # use curr user

			# call create
			post :create, ticket: ticket_attrs, format: :json

			# ensure user can create
			expect(response).to be_success

			# ensure correct data is returned
			# check if a ticket was created
			expect(Ticket.all.count).to eq(tickets_count+1)
			# check if a last ticket created is from current user
			expect(Ticket.all.last.user_id).to eq(@user.id)
		end

		# admins can update tickets
		it 'update' do
			# create fake ticket to be updated
			ticket = FactoryGirl.create(:ticket)

			# set attributes to be updated
			ticket_attrs = ticket.as_json.merge!(category: 'Task', description: 'Updated by RSpec')

			# call update
			put :update, id: ticket.id, ticket: ticket_attrs, format: :json

			# ensure user can update
			expect(response).to be_success

			# ensure correct data is returned
			# updated record should have matching values for attr keys sent
			ticket.reload # record must be reloaded with change
			expect(ticket.category).to eq(ticket_attrs[:category])
			expect(ticket.description).to eq(ticket_attrs[:description])
		end

		# admins can destroy tickets
		it 'destroy' do
			# create fake ticket to be destroyed
			ticket = FactoryGirl.create(:ticket)

			# get initial count of tickets
			tickets_count = Ticket.all.count

			# call destroy
			delete :destroy, id: ticket.id, format: :json

			# ensure user cannot destroy
			expect(response).to be_success

			# ensure no records have be deleted
			expect(Ticket.all.count).to eq(tickets_count-1)
		end

		# admins can close tickets
		it 'close' do
			# create fake ticket to be closed
			ticket = FactoryGirl.create(:ticket)

			# call close
			post :close, id: ticket.id, format: :json

			# ensure user cannot close
			expect(response).to be_success

			# ensure ticket was not updated
			ticket.reload # record must be reloaded to ensure check for change
			expect(ticket.status).to eq('Closed')
		end
	end
end