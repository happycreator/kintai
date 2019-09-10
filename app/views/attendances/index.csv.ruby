require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出社 退社 備考 )
  csv << column_names
  @attendances.each do |attendance|
    if attendance.arriving_at && attendance.leaving_at
      column_values = [
        attendance.attendance_date,
        attendance.arriving_at.strftime("%-H:%M"),
        attendance.leaving_at.strftime("%-H:%M"),
        attendance.note,
      ]
    else
      column_values = [
        attendance.attendance_date,
        attendance.arriving_at,
        attendance.leaving_at,
        attendance.note,
      ]
    end
    csv << column_values
  end
end