class CommentsController < ApplicationController
    def create
        road_condition = RoadCondition.find(params[:road_condition_id])
        comment = current_user.comments.new(comment_params)
        comment.road_condition_id = road_condition.id
        comment.save
        redirect_to road_condition_path(road_condition)
    end
    
    def destroy
        Comment.find_by(id: params[:id], road_condition_id: params[:road_condition_id]).destroy
        redirect_to road_condition_path(params[:road_condition_id])
    end
    
    private
    def comment_params
        params.require(:comment).permit(:comment)
    end
end