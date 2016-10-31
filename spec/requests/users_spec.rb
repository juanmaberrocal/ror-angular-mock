require 'spec_helper'

# user specs
RSpec.describe Api::V1::UsersController, type: :controller do
	
	# ensure users cannot access any of the requests
	describe "User Actions for User" do 
		login_user

		# users cannot view users
		it 'index' do 
			# build fake users
			users = FactoryGirl.create_list(:user, rand(1..10))

			# call index
			get :index, format: :json

			# ensure user can view
			expect(response).to_not be_success
		end

		# users cannot view specific users
		it 'show' do
			# create fake user
			user = FactoryGirl.create(:user)

			# call show
			get :show, id: user.id, format: :json

			# ensure user can view
			expect(response).to_not be_success
		end

		# users cannot create new users
		it 'create' do
			# keep track of initial amount of users
			users_count = User.all.count

			# init user
			user_attrs = FactoryGirl.attributes_for(:user)

			# call create
			post :create, user: user_attrs, format: :json

			# ensure user can create
			expect(response).to_not be_success

			# ensure no user was created
			expect(User.all.count).to eq(users_count)
		end

		# users cannot update users
		it 'update' do
			# create fake user to be updated
			user = FactoryGirl.create(:user)

			# set attributes to be updated
			user_attrs = user.as_json.merge!(username: 'RSpec User', admin: true)

			# call update
			put :update, id: user.id, user: user_attrs, format: :json

			# ensure user can update
			expect(response).to_not be_success

			# ensure record doesnt have matching values for attr keys sent
			user.reload # record must be reloaded with change
			expect(user.username).to_not eq(user_attrs[:username])
			expect(user.admin).to_not eq(user_attrs[:admin])
		end

		# users cannot destroy users
		it 'destroy' do
			# create fake user to be destroyed
			user = FactoryGirl.create(:user)

			# get initial count of users
			users_count = Ticket.all.count

			# call destroy
			delete :destroy, id: user.id

			# ensure user cannot destroy
			expect(response).to_not be_success

			# ensure no records have be deleted
			expect(Ticket.all.count).to eq(users_count)
		end

		# users cannot toggle admin priveleges users
		it 'toggle_admin' do
			# create fake user to be closed
			user = FactoryGirl.create(:user)

			# call close
			post :toggle_admin, id: user.id, admin: true

			# ensure user cannot close
			expect(response).to_not be_success

			# ensure user was not updated
			user.reload # record must be reloaded to ensure check for change
			expect(user.admin).to eq(false)
		end
	end

	# ensure admins have access to all request
	describe "User Actions for Admins" do
		login_admin

		# admins can view users
		it 'index' do 
			# build fake users
			users = FactoryGirl.create_list(:user, rand(1..10))

			# call index
			get :index, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct amount of records returned
			expect(json.length).to eq(users.length+1) # account for user created at login
		end

		# admins can view specific users
		it 'show' do
			# create fake user
			user = FactoryGirl.create(:user)

			# call show
			get :show, id: user.id, format: :json

			# ensure user can view
			expect(response).to be_success

			# ensure correct data is returned
			# controller rebuilds response, so just ensure same record is returned
			expect(json["id"]).to eq(user.id)
		end

		# admins can create new users
		it 'create' do
			# keep track of initial amount of users
			users_count = User.all.count

			# init user
			user_attrs = FactoryGirl.attributes_for(:user)

			# call create
			post :create, user: user_attrs, format: :json

			# ensure user can create
			expect(response).to be_success

			# ensure correct data is returned
			# check if a user was created
			expect(User.all.count).to eq(users_count+1)
		end

		# admins can update users
		it 'update' do
			# create fake user to be updated
			user = FactoryGirl.create(:user)

			# set attributes to be updated
			user_attrs = user.as_json.merge!(username: 'RSpec User', admin: true)

			# call update
			put :update, id: user.id, user: user_attrs, format: :json

			# ensure user can update
			expect(response).to be_success

			# ensure correct data is returned
			# updated record should have matching values for attr keys sent
			user.reload # record must be reloaded with change
			expect(user.username).to eq(user_attrs[:username])
			expect(user.admin).to eq(user_attrs[:admin])
		end

		# admins can destroy users
		it 'destroy' do
			# create fake user to be destroyed
			user = FactoryGirl.create(:user)

			# get initial count of users
			users_count = User.all.count

			# call destroy
			delete :destroy, id: user.id, format: :json

			# ensure user cannot destroy
			expect(response).to be_success

			# ensure no records have be deleted
			expect(User.all.count).to eq(users_count-1)
		end

		# admins can toggle admin priveleges users
		it 'toggle_admin' do
			# create fake user to be toggled
			user = FactoryGirl.create(:user)

			# call toggle_admin
			post :toggle_admin, id: user.id, admin: true

			# ensure user cannot close
			expect(response).to be_success

			# ensure user was updated
			user.reload # record must be reloaded to ensure check for change
			expect(user.admin).to eq(true)
		end
	end
end