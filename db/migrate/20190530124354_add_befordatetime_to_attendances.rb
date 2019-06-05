class AddBefordatetimeToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :before_change_arriving_at, :datetime
    add_column :attendances, :before_change_leaving_at, :datetime
  end
end
