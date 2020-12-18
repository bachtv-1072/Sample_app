class FollowingController < ApplicationController
  before_action :load_user

  def index
    @title = t "follow.following"
    @users = @user.following.page(params[:page]).per Settings.panigate.users
    render "users/show_follow"
  end
end
