class FollowersController < ApplicationController
  before_action :load_user

  def index
    @title = t "follow.follower"
    @users = @user.followers.page(params[:page]).per Settings.panigate.users
    render "users/show_follow"
  end
end
