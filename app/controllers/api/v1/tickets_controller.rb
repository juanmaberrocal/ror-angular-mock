module Api
	module V1
		class TicketsController < ApplicationController
			# ensure user is logged in
			before_action :authenticate_user!

			# ensure user is admin
			before_action :authenticate_admin!, only: [:destroy, :close, :report]

			# set ticket
			before_action :set_ticket, only: [:show, :update, :destroy, :close]

			# default to json response
			respond_to :json

			def index
				# build json response and include owner
				response = Ticket.all.includes(:user).map{ |t| t.as_json.merge(owner: t.owner) }

				# return response of all tickets and their owner
				respond_with response
			end

			def show
				# return with owner and closer
				response = @ticket.as_json.merge!(owner: @ticket.owner, closer: @ticket.closer)

				# return response with owner and closer
				respond_with response
			end

			# todo: change to begin|rescue block for controlled json response
			def create
				# respond_with handles errors in create fail
				respond_with :api, :v1, Ticket.create(ticket_params)
			end

			# todo: change to begin|rescue block for controlled json response
			def update
				# respond_with handles errors in update fail
				respond_with @ticket.update(ticket_params)
			end

			# todo: change to begin|rescue block for controlled json response
			def destroy
				# respond_with handles errors in destroy fail
				respond_with @ticket.destroy
			end

			# custom methods
			# close ticket
			def close
				begin
					# ticket can only be closed once
					raise 'Ticket has been closed already!' if @ticket.status == 'Closed'
					# update ticket status
					@ticket.update_attributes({
						status: 'Closed',
						closed_by: current_user.id,
						closed_on: DateTime.now
					})

					# return with owner and closer
					response = @ticket.as_json.merge!(owner: @ticket.owner, closer: @ticket.closer)

					# return ticket with owner and closer
					render json: response
				rescue => e
					# return error message
					render json: { errors: e.message }, status: :unprocessable_entity
				end
			end

			# load report
			def report
				# get range of days (past month)
				date_start = Date.today - 1.month
				date_end = DateTime.now

				# get tickets for report
				response = Ticket.includes(:user)
					.where(status: 'Closed', closed_on: (date_start..date_end)) # ensure tickets were closed in the past month
					.map{ |t| t.as_json.merge(owner: t.owner, closer: t.closer) } # build response including owner and closer

				# return response of closed tickets in the past month with their owner and who closed it
				respond_with response
			end

			# load options
			# used for angular forms to keep available options synced
			def statuses
				respond_with Ticket::STATUSES
			end

			def categories
				respond_with Ticket::CATEGORIES
			end

			private
			# set ticket
			def set_ticket
				@ticket = Ticket.find(params[:id])
			end

			# white-list params
			def ticket_params
				params.fetch(:ticket, {}).permit(:user_id, :title, :category, :status, :description)
			end


		end
	end
end