class RelationshipsController < ApplicationController
    def create
        current_user.follow(params[:user_id])

        #通知作成
        @user.create_notification_follow!(current_user)
        
        redirect_to request.referer
    end
      
    def destroy
        current_user.unfollow(params[:user_id])
        redirect_to request.referer
    end
end