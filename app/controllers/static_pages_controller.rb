class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.includes(:user, :likes).desc
        .page(params[:page]).per Settings.size_page_max_length
      if @feed_items.blank?
        redirect_to root_path
      end
    end
  end

  def help; end

  def about; end

  def contact; end
end
