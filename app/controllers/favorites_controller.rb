class FavoritesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @road_condition = RoadCondition.find(params[:road_condition_id])
      current_user.favorite(@road_condition)
  
      respond_to do |format|
        format.html { redirect_to @road_condition }
        format.turbo_stream
      end
    end
  
    def destroy
      @road_condition = RoadCondition.find(params[:road_condition_id])
      current_user.unfavorite(@road_condition)
  
      respond_to do |format|
        format.html { redirect_to @road_condition }
        format.turbo_stream
      end
    end
  end
  