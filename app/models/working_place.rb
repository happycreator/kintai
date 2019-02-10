class WorkingPlace < ApplicationRecord
  validates :working_place_number, numericality: { only_integer: true }
end