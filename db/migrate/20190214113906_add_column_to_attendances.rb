class AddColumnToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :monthly_confirmation_approver_id, :integer
    add_column :attendances, :monthly_confirmation_status, :integer
  end
end
