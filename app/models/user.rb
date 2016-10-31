class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :validatable
  include DeviseTokenAuth::Concerns::User

  # add validate for username
  validates :username, presence: true

  # users can create multiple tickets
  has_many :tickets
end
