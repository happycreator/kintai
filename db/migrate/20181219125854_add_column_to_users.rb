class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :role, :integer
    add_column :users, :base_attendance_time, :datetime
    add_column :users, :start_attendance_time, :datetime
    add_column :users, :end_attendance_time, :datetime
  end
end
