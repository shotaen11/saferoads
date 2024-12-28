class FavoritesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @road_condition = RoadCondition.find(params[:road_condition_id])
      current_user.favorite(@road_condition)
  
      # 通知を作成
      @road_condition.create_notification_favorite!(current_user)

      respond_to do |format|
        format.turbo_stream
      end
    end
  
    def destroy
        @road_condition = RoadCondition.find(params[:road_condition_id])
        current_user.unfavorite(@road_condition)
        Rails.logger.debug "Favorites count after destroy: #{@road_condition.favorites.count}"
        respond_to do |format|
          format.turbo_stream
        end
    end
    

  end
  