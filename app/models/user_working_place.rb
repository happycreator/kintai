class UserWorkingPlace < ApplicationRecord
  belongs_to :user
  belongs_to :working_place
  has_many :working_places, dependent: :destroy
  has_many :users, through: :user_working_places
end