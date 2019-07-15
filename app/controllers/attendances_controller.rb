class AttendancesController < ApplicationController
  def index
    @user = current_user
    #指示者確認（印）上長の選択
    @seniors = User.where(is_senior: true).map(&:name)

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
      if !@user.attendances.where('attendance_date = ?', date).present? 
        linked_attendance = Attendance.new(user_id: @user.id, attendance_date: date)
        linked_attendance.save
      end
    end
    # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    @attendances = @user.attendances.where('attendance_date >= ? and attendance_date <= ?', @first_day, @last_day).order("attendance_date ASC")

    # 上長画面で一ヶ月分勤怠申請のお知らせをカウントする
    @monthly_confirmation_count = Attendance.monthly_confirmation(current_user)

    # 上長画面で勤怠変更申請のお知らせをカウントする
    @change_confirmation_count = Attendance.change_confirmation(current_user)

    # 上長画面で残業申請のお知らせをカウントする
    @overwork_confirmation_count = Attendance.overwork_confirmation(current_user)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
    @attendance = Attendance.find(params[:id])
    @seniors = User.where(is_senior: true).map(&:name)
    @youbi = %w[日 月 火 水 木 金 土]
  end

  #残業申請モーダルフォーム
  def update
    @attendance = Attendance.find(params[:id])

    tmp_date = @attendance.attendance_date
    tmp_hour = params[:attendance][:overtime].split(":")[0].to_i
    tmp_min = params[:attendance][:overtime].split(":")[1].to_i
    @attendance.overtime = tmp_date + tmp_hour.hour + tmp_min.minute

    #チェックボックスはifで分岐だけでデータベースには入れない
    if params[:overday_check]
      @attendance.overtime = @attendance.overtime + 1.day
    end

    @attendance.user_id = current_user.id
    #指示者確認・パラメーターでユーザーの名前を検索してidを入れる
    @attendance.overwork_approver_id = User.where(name: params[:user][:name]).first.id
    @attendance.overwork_status = :pending
    @attendance.task_memo = params[:attendance][:task_memo]
    if @attendance.save
      redirect_to attendances_path, notice: '残業申請を送付しました。'
    else
      redirect_to attendances_path, notice: '残業申請は失敗しました。'
    end
  end

  def destroy
  end

  # 出勤・退社ボタン押下show.html.erbの出社・退社押下時反応
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
    redirect_to attendances_path
  end

  #勤怠変更ページの表示
  def attendance_edit
    @user = User.find(params[:id])
    #指示者確認（印）上長の選択
    @seniors = User.where(is_senior: true).map(&:name)

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

    #勤怠変更ページ更新
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
            if params["attendances"][id]["change_confirmation_approver_id"]
              item["before_change_arriving_at"] = attendance.arriving_at
              item["before_change_leaving_at"] = attendance.leaving_at
              item["change_confirmation_approver_id"] = User.where(name: params["attendances"][id]["change_confirmation_approver_id"]).first.id.to_i
              item["change_confirmation_status"] = :pending
              attendance.update_attributes(item)
              flash[:success] = '勤怠時間を更新しました。'
            else
              attendance.update_attributes(item)
              flash[:success] = '勤怠時間を更新しました。'
            end
          end
        end #eachの締め
      end
      redirect_to attendances_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
    end

  #ユーザーの一ヶ月分の勤怠申請
  def monthly_confirmation
    @first_day = params[:year_month]
    #datetimeに変換
    @first_day = @first_day.to_datetime
    @last_day = @first_day.end_of_month
    #パラメーターでユーザーの名前を検索してidを入れる
    _id = User.where(name: params[:user][:name]).first.id
    #一ヶ月分の勤怠検索して上長IDとステータスの申請して保存する
    Attendance.where('attendance_date >= ? and attendance_date <= ?', @first_day-1.minute, @last_day-9.hour).update_all(:monthly_confirmation_approver_id => _id, :monthly_confirmation_status => :pending)
  end

  #上長モーダル画面・ユーザーからの1ヶ月勤怠申請を表示
  def monthly_confirmation_form
    #未承認かつidが上長current_user
    @attendances = Attendance.where(monthly_confirmation_status: :pending, monthly_confirmation_approver_id: current_user.id)
    #ユーザー（user_id)ごとに勤怠のオブジェクトを分ける
    tmp_pending_users = @attendances.group_by(&:user_id)
    #未承認のユーザーの名前と、何月分の一ヶ月勤怠申請なのか
    #@pending_usersをハッシュとして定義
    @pending_users = {}
    tmp_pending_users.each do |user_id, attendances|
      year_month_arr = []
      attendances.each do |attendance|
        year_month_arr << attendance.attendance_date.year.to_s + attendance.attendance_date.month.to_s
      end
      #uniqメソッドでかなさっているのもを一つにまとめる
      year_month_arr.uniq
      @pending_users.store(User.find(user_id), year_month_arr.uniq)
    end
  end

  #first_dayとlast_dayをアウトプットするメソッド
  def first_day_last_day_output(year_month)
    year = year_month.chop
    month = year_month.scan(/.{1,4}/).last
    month = "%02d" % (month.to_i)
    #datetimeに変換
    @first_day = (year + month + "01").to_datetime
    @last_day = @first_day.end_of_month
    #多値返却
    return @first_day, @last_day
  end

  #上長がモーダル画面でユーザーからの一ヶ月勤怠のステータス変更を保存
  def monthly_confirmation_status_update
    #多値返却
    @first_day, @last_day = first_day_last_day_output(params[:year_month])
    #ユーザーごとの申請
    @user = User.where(name: params[:user_name]).first
    #どのユーザの？一ヶ月の勤怠で、どの上長（id）が承認したのか
    @user.attendances.where('attendance_date >= ? and attendance_date <= ?', @first_day-1.minute, @last_day-9.hour).update_all(:monthly_confirmation_approver_id => current_user.id, :monthly_confirmation_status => params[:attendance][:monthly_confirmation_status])
  end

  #上長画面モーダルより、申請者の該当月の勤怠画面を表示
  def monthly_attendance_show
    #多値返却
    @first_day, @last_day = first_day_last_day_output(params[:year_month])
    #ユーザーごとの申請
    @user = User.where(name: params[:user_name]).first
    # 表示期間の勤怠データを日付順にソートして取得 view<% @attendances.each do |attendance| %>からの情報
    @attendances = @user.attendances.where('attendance_date >= ? and attendance_date <= ?', @first_day-1.minute, @last_day-9.hour).order("attendance_date ASC")
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    #指示者確認（印）上長の選択
    @senior = current_user
  end

  #上長画面モーダルより、ユーザーの勤怠変更申請勤を表示
  def change_confirmation_form
    #未承認かつidが上長current_userの勤怠
    @attendances = Attendance.where(change_confirmation_status: :pending, change_confirmation_approver_id: current_user.id)
    #ユーザー（user_id)ごとに勤怠のオブジェクトを分ける
    tmp_pending_users = @attendances.group_by(&:user_id)
    @pending_users = {}
    tmp_pending_users.each do |user_id, attendances|
      attendance_arr = []
      attendances.each do |attendance|
        attendance_arr << attendance
      end
      #storeメソッドでハッシュにキーkeyと値valのペアを追加
      @pending_users.store(User.find(user_id), attendance_arr)
    end
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
  end

  #上長画面モーダルより、ユーザーの勤怠変更申請勤を保存
  def change_confirmation_status_update
    @user = User.where(name: params[:user_name]).first
    params[:attendances].each do |d|
      attendace = Attendace.where(attendance_date: d[:attendance_date], user_id: @user.id).first
      attendace.change_confirmation_status = d[:change_confirmation_status]
      #チェックボックスはifで分岐だけでデータベースには入れない
      if params[:change_confirmation_checked]
        attendance.attendance_date = @attendance.attendance_date
        attendace.save
      end
    end
  end

  def overwork_confirmation_form
    @attendances = Attendance.where(overwork_status: :pending, overwork_approver_id: current_user.id)
    #ユーザー（user_id)ごとに勤怠のオブジェクトを分ける
    tmp_pending_users = @attendances.group_by(&:user_id)
    @pending_users = {}
    tmp_pending_users.each do |user_id, attendances|
      attendance_arr = []
      attendances.each do |attendance|
        attendance_arr << attendance
      end
      #storeメソッドでハッシュにキーkeyと値valのペアを追加
      @pending_users.store(User.find(user_id), attendance_arr)
    end
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
  end

  def overwork_confirmation_status_update
  end

  def attendance_logs
    #承認かつidが上長current_userの勤怠
    @attendances = Attendance.where(change_confirmation_status: :approval, change_confirmation_approver_id: current_user.id)
    #ユーザー（user_id)ごとに勤怠のオブジェクトを分ける
    tmp_approval_users = @attendances.group_by(&:user_id)
    @approval_users = {}
      tmp_approval_users.each do |user_id, attendances|
        attendance_arr = []
        attendances.each do |attendance|
        attendance_arr << attendance
      end
      #storeメソッドでハッシュにキーkeyと値valのペアを追加
      @approval_users.store(User.find(user_id), attendance_arr)
    end
  end

  private

  def attendances_params
    params.permit(attendances: [:arriving_at, :leaving_at, :note, :attendance_date, :overtime, :task_memo, :change_confirmation_approver_id,
    :change_confirmation_status, :user_id, :overwork_status, :overwork_approver_id, :monthly_confirmation_approver_id, :monthly_confirmation_status,
    :before_change_arriving_at, :before_change_leaving_at])[:attendances]
  end
end