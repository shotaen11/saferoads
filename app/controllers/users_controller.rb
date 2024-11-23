class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @road_conditions = @user.road_conditions.page(params[:page]).per(8).reverse_order
  end
end
