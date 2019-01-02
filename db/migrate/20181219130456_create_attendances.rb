class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.datetime :arriving_at
      t.datetime :leaving_at
      t.string :note
      t.date :attendance_date
      t.datetime :overtime
      t.text :task_memo
      t.integer :change_confirmation_approver_id
      t.integer :change_confirmation_status
      t.integer :overwork_status
      t.integer :overwork_approver_id
      t.references :user
      t.timestamps
    end
  end
end