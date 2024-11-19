class FavoritesController < ApplicationController
    def create
        road_condition = RoadCondition.find(params[:road_condition_id])
        favorite = current_user.favorites.new(road_condition_id: road_condition.id)
        favorite.save
        redirect_to road_condition_path(road_condition)
    end

    def destroy
        road_condition = RoadCondition.find(params[:road_condition_id])
        favorite = current_user.favorites.find_by(road_condition_id: road_condition.id)
        favorite.destroy
        redirect_to road_condition_path(road_condition)
    end
end
