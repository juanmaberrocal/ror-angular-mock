module Api
	module V1
		class UsersController < ApplicationController
			# ensure user is logged in
			before_action :authenticate_user!

			# ensure user is admin
			before_action :authenticate_admin!

			# set user
			before_action :set_user, only: [:show, :update, :destroy, :toggle_admin]

			# default to json response
			respond_to :json

			def index
				# build json response and include owner
				response = User.all

				# return response of all users and their owner
				respond_with response
			end

			def show
				# return with owner and closer
				response = @user.as_json

				# return response with owner and closer
				respond_with response
			end

			def create
				# respond_with handles errors in create fail
				respond_with :api, :v1, User.create(user_params)
			end

			def update
				# respond_with handles errors in update fail
				respond_with @user.update(user_params)
			end

			def destroy
				# respond_with handles errors in destroy fail
				respond_with @user.destroy
			end

			# custom methods
			# toggle user admin role
			def toggle_admin
				begin
					# user cannot modify self admin role
					raise 'You cannot modify your own admin role!' if @user.id == current_user.id
					# update user status
					@user.update_attributes({
						admin: params[:admin]
					})

					# return updated user
					response = @user.as_json

					render json: response
				rescue => e
					# return error message
					render json: { errors: e.message }, status: :unprocessable_entity
				end
			end

			private
			# set user
			def set_user
				@user = User.find(params[:id])
			end

			# white-list params
			def user_params
				params.fetch(:user, {}).permit(:username, :password, :email, :admin)
			end

		end
	end
end