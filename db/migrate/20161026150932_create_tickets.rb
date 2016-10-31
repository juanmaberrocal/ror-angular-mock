class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :user, index: true
      t.string :title
      t.string :category
      t.string :status
      t.text :description

      # created|updated timestamps
      t.timestamps
    end
  end
end
