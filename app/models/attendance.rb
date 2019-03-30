class Attendance < ApplicationRecord
  enum monthly_confirmation_status: { nothing: 0, pending: 1, approval: 2, denial: 3 }
  
  # 【所属長承認のお知らせ】一ヶ月支持者確認がログインユーザーで、ステータスが未承認かどうか＆何月分の勤怠
  def self.monthly_confirmation(current_user)
    attendances = self.where(monthly_confirmation_status: :pending, monthly_confirmation_approver_id: current_user.id)
    binding.pry
    abc = Hash.new(0)
    year_month_arr = []
    attendances.all.each do |attendance|
      p attendance.attendance_date
      year_month_arr << attendance.attendance_date.year.to_s + attendance.attendance_date.month.to_s
    end
    year_month_arr.each do |elem|
      abc[elem] += 1
    end
    
    attendances.attendance_date
    attendances.count
  end
    
  # self.all.each do |attendance|
  #   # 一ヶ月支持者確認がログインユーザーかどうか
  #   if attendance.monthly_confirmation_approver_id == current_user.id && attendance.monthly_confirmation_status == :pending
  #   # ステータスが未承認かどうか
  #   end
  #     return "#{@monthly_confirmation_count}件"
  # end
end