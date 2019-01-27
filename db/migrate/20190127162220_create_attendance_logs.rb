class CreateAttendanceLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_logs do |t|
      t.date :attendance_date
      t.datetime :arriving_at_before_update
      t.datetime :leaving_at_before_update
      t.datetime :arriving_at_after_update
      t.datetime :leaving_at_after_update
      t.integer :change_confirmation_approver_id
      t.date :approval_date

      t.timestamps
    end
  end
end
