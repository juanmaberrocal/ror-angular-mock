class Ticket < ActiveRecord::Base
	# ticket statuses
	STATUSES = %w(Open Closed) # First value used as default

	# ticket categories
	CATEGORIES = %w(Bug Change Task) # First value used as default
	
	# title required
	# user required
	validates :title, :user, presence: true

	# ticket category must be available category
	validates :category, inclusion: { in: CATEGORIES }

	# ticket status must be available status
	validates :status, inclusion: { in: STATUSES }

	# ensure ticket has an owner
	# validates_associated :user # validated through presence

	# every ticket has 1 owner
	belongs_to :user

	# every ticket has 1 closer
	belongs_to :user_closer, class_name: User, foreign_key: 'closed_by', primary_key: 'id'

	# default order
	default_scope { order(id: :desc) }

	# instance methods
	# get owner of ticket as username of associated user
	def owner
		self.user.username rescue 'Ticket has no owner!'
	end

	# get username of user that closed ticket
	def closer
		# only look for closer if ticket was closed
		if self.status == 'Closed'
			self.user_closer.username rescue 'Ticket has no closer!'
		else
			'Ticket has not been closed!'
		end
	end
end