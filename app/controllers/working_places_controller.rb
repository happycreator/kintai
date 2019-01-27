class WorkingPlacesController < ApplicationController 
  def index
    @working_places = WorkingPlace.all.order(created_at: :asc)
  end
  
  def new
    @working_place = WorkingPlace.new
  end
  
  def create
    @working_place = WorkingPlace.new(working_place_params)
    if @working_place.save
      flash.now[:success] = "拠点情報が登録されました"
      redirect_to working_places_path
    else
      flash.now[:danger] = @working_place.errors.messages
      render 'new'
    end
  end
  
  def edit
    @working_place = WorkingPlace.find(params[:id])
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
end