class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  # 下書き投稿は、非表示
  def show
    @user = User.find(params[:id])
    @road_conditions = @user.road_conditions.merge(RoadCondition.published_only).page(params[:page]).per(8).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def remove_profile_image
    @user = User.find(params[:id])  
    if @user == current_user  # 現在のユーザーと一致する場合のみ削除
      @user.profile_image.purge # プロフィール画像の削除
      redirect_to edit_user_path(@user), notice: 'プロフィール画像を削除しました'
    else
      redirect_to root_path, alert: '他のユーザーの画像は削除できません'
    end
  end
  

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end
  
  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
