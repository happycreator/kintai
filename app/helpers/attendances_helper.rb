module AttendancesHelper
  def attendance_count
    Attendance.where(user_id: params[:id], attendance_date: Time.new(@first_day.year,@first_day.month).all_month).select("leaving_at").count
  end
  
  # 在社時間計上用
  def working_hours(a,b)
    arriving_at = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    leaving_at = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    #(((leaving_at - arriving_at) / 60) / 60).truncate()
    (Time.parse("1/1") + (leaving_at - arriving_at)).strftime("%H時間%M分")
  end
  
  # 引数の時刻データの秒を０にして差を求める
  def times(x,y)
    c = Time.mktime(x.year, x.month, x.day, x.hour, x.min, 0, 0)
    d = Time.mktime(y.year, y.month, y.day, y.hour, y.min, 0, 0)
    (d - c).to_i
  end
  
  # 基本時間などの時刻データを指定の１０段階表示にする
  def basic_info_time(t)
    format("%.2f", ((t.hour * 60.0) + t.min)/60) if !t.blank?
  end
end
