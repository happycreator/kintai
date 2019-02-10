class WorkingPlacesController < ApplicationController 
  def index
    @working_places = current_user.working_places
  end
  
  def new
    @working_place = WorkingPlace.new
  end
  
  def create
    return unless current_user.admin
    @working_place = WorkingPlace.new(working_place_params)
    ActiveRecord::Base.transaction do
      create_association
      if @working_place.save
        flash.now[:success] = "拠点情報が登録されました"
        redirect_to working_places_path
      else
        flash.now[:danger] = @working_place.errors.messages
        render 'new'
      end
    end
    rescue => e
  end
  
  def edit
    @working_place = current_user.working_places.where(working_places: { id: params[:id] }).first
  end
  
  def update
    @working_place = WorkingPlace.find(params[:id])
    if @working_place.update_attributes(working_place_params)
      flash[:success] = "拠点情報を変更しました。"
      redirect_to working_places_path
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end
  
    
  def destroy
    WorkingPlace.find(params[:id]).destroy
    flash[:danger] = "拠点情報を削除しました。"
    redirect_to working_places_path
  end
  
  private
  def working_place_params
    params.require(:working_place).permit(
      :working_place_number,
      :working_place_name,
      :working_type
    )
  end
  
  def create_association
    # 関連を保存する
    current_user.working_places << @working_place
  end
end