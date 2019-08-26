class AddMonthlyConfirmationApprovalOnToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :monthly_confirmation_approval_on, :datetime
  end
end
