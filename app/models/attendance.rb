class Attendance < ApplicationRecord
  enum monthly_confirmation_status: { nothing: 0, pending: 1, approval: 2, denial: 3 }
end