class Attendance < ApplicationRecord
  enum monthly_confirmation_status: { nothing: 0, pending: 1, approval: 2, denial: 3 }
  enum change_confirmation_status: { nothing: 0, pending: 1, approval: 2, denial: 3 }, _prefix: true
  
  # 【所属長承認のお知らせ】一ヶ月支持者確認がログインユーザーで、ステータスが未承認かどうか＆何月分の何件の勤怠
  def self.monthly_confirmation(current_user)
    attendances = self.where(monthly_confirmation_status: :pending, monthly_confirmation_approver_id: current_user.id)
    year_month_arr = []
    attendances.all.each do |attendance|
      year_month_arr << attendance.attendance_date.year.to_s + attendance.attendance_date.month.to_s
    end
    year_month_arr.uniq.count
  end

# 【勤怠変更申請のお知らせ】勤怠変更申請の確認がログインユーザーで、ステータスが未承認かどうか＆何日の何件なのか
  def self.change_confirmation(current_user)
    attendances = self.where(change_confirmation_status: :pending, change_confirmation_approver_id: current_user.id)
    attendances.count
  end
end