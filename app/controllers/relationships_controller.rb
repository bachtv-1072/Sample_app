class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
    else
      @success = t "follow.follow_fail"
    end
    respond_to :js
  end

  def destroy
    @user = Relationship.find_by id: params[:id]
    if @user.present?
      @user = @user.followed
      current_user.unfollow @user
    else
      @success = t "follow.unfollow_fail"
    end
    respond_to :js
  end
end
