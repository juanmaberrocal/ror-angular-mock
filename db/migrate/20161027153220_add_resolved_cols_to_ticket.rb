class AddResolvedColsToTicket < ActiveRecord::Migration
  def change
  	add_column :tickets, :closed_by, :string
  	add_column :tickets, :closed_on, :datetime
  end
end
