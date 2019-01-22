class AttendancesController < ApplicationController
  def index
    @user = current_user
    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    # 最終日を取得する
    @last_day = @first_day.end_of_month
    # 今月の初日から最終日の期間分を取得
    (@first_day..@last_day).each do |date|
      # 該当日付のデータがないなら作成する
      #(例)user1に対して、今月の初日から最終日の値を取得する
      if !@user.attendances.any? {|attendance| attendance.attendance_date == date }
        linked_attendance = Attendance.new(user_id: @user.id, attendance_date: date)
        linked_attendance.save
      end
    end
    # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    @attendances = @user.attendances.where('attendance_date >= ? and attendance_date <= ?', @first_day, @last_day).order("attendance_date ASC")
  end
  
  def new
    @attendance_date = params[:attendance_date]
    @wday = params[:wday]
    @attendance = Attendance.new
    @seniors = User.where(is_senior: true).map(&:name)
  end
  
  def create
    @attendance = Attendance.new
    @attendance.attendance_date = params[:attendance_date].to_date
    
    tmp_date = params[:attendance_date].to_date
    tmp_hour = params[:attendance][:overtime].split(":")[0].to_i
    tmp_min = params[:attendance][:overtime].split(":")[1].to_i

    @attendance.overtime = tmp_date + tmp_hour.hour + tmp_min.minute
    @attendance.task_memo = params[:attendance][:task_memo]
    if @attendance.save
      redirect_to attendances_path, notice: '残業申請を送付しました。' 
    else
      redirect_to attendances_path, notice: '残業申請は失敗しました。' 
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  # 出勤・退社ボタン押下　show.html.erbの出社・退社押下時反応
  def attendance_update
    # 更新する勤怠データを取得
    @attendance = Attendance.find(params[:attendance][:id])
    # 更新パラメータを文字列で取得する
    @update_type = params[:attendance][:update_type]

    if @update_type == 'arriving_at'
      # 出社時刻を更新 
      if !@attendance.update_column(:arriving_at, DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day,DateTime.now.hour,DateTime.now.min,0))
        flash[:error] = "出社時間の入力に失敗しました"
      end
    elsif @update_type == 'leaving_at'
      # 退社時刻を更新 
      if !@attendance.update_column(:leaving_at, DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day,DateTime.now.hour,DateTime.now.min,0))
        flash[:error] = "退社時間の入力に失敗しました"
      end
    end  
    #出社・退社押下した日付及び現在のuser idを@userに返す
    @user = User.find(params[:attendance][:user_id])
    redirect_to @user
  end
  
  
  def attendance_edit
    @user = User.find(params[:id])

    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month

    # 今月の初日から最終日の期間分を取得
    (@first_day..@last_day).each do |date|
      # 該当日付のデータがないなら作成する
      #(例)user1に対して、今月の初日から最終日の値を取得する
      if !@user.attendances.any? {|attendance| attendance.attendance_date == date }
        linked_attendance = Attendance.create(user_id: @user.id, day: date)
        linked_attendance.save
      end
      
    # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    @attendances = @user.attendances.where('attendance_date >= ? and attendance_date <= ?', @first_day, @last_day).order("attendance_date ASC")
    end
  end

  #編集ページ更新  
  def attendance_update_all
    @user = User.find_by(id: params[:id])
    error_count = 0
    message = ""
    
    attendances_params.each do |id, item|
      attendance = Attendance.find(id)
      
      #出社時間と退社時間の両方の存在を確認
      if item["arriving_at"].blank? && item["leaving_at"].blank?
        message = '一部編集が無効となった項目があります。'
        
      # 当日以降の編集はadminユーザのみ
      elsif attendance.attendance_date > Date.current && !current_user.admin?
        message = '明日以降の勤怠編集は出来ません。'
        error_count += 1
      
      #出社時間 > 退社時間ではないか
      elsif item["arriving_at"].to_s > item["leaving_at"].to_s
        message = '出社時間より退社時間が早い項目がありました'
        error_count += 1
      end
    end #eachの締め
    
    if error_count > 0
      flash[:warning] = message
    else
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        
        # 当日以降の編集はadminユーザのみ
        if item["arriving_at"].blank? && item["leaving_at"].blank?
        
        else
          attendance.update_attributes(item)
          flash[:success] = '勤怠時間を更新しました。'
        end
      end #eachの締め
    end
    redirect_to attendances_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
  end
  
  private

  def attendances_params
    params.permit(attendances: [:arriving_at, :leaving_at])[:attendances]
  end
end