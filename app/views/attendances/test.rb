pending_users = {1 => ["3月1日", "3月2日", "4月1日", "4月2日"],
                 2 => ["2月1日", "2月2日", "5月1日", "5月2日"]
}

pending_users = {}

pending_users.each do |user_id, attendances|
  year_month_arr = []
  attendances.each do |attendance|
    year_month_arr << attendance.attendance_date.year.to_s + attendance.attendance_date.month.to_s
  end
  year_month_arr.uniq
  pending_users.store(User.find(user_id).name, year_month_arr.uniq)
end
