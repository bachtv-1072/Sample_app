class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.order_post.page(params[:page]).per Settings.panigate.users
  end

  def help; end
end
