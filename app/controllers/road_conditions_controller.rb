class RoadConditionsController < ApplicationController
  def new
    @road_condition = RoadCondition.new
  end

  def create
    @road_condition = RoadCondition.new(road_conditions_params)
    if @road_condition.save
      redirect_to road_condition_path(@road_condition)
    else
      render :new
    end
  end

  def index
    @road_conditions = RoadCondition.all
  end

  def show
    @road_condition = RoadCondition.find(params[:id])
  end

  private
  def road_conditions_params
    params.require(:road_condition).permit(:road_name, :road_status, :description)
  end
end
