class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy
  before_action :find_micropost, only: %i(edit update destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    load_feed_items
    respond_to do |format|
      format.json do
        @micropost.save if @micropost.valid?
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @micropost.update_attributes micropost_params
        load_feed_items
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @micropost.destroy
        load_feed_items
        if @feed_items.blank? && params[:page].to_i != 1
          params[:page] = (params[:page].to_i - 1).to_s
          load_feed_items
        end
        format.json
      end
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def find_micropost
    @micropost = Micropost.find_by id: params[:id]

    return if @micropost
    flash[:danger] = "Micropost not found!"
    redirect_to root_path
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end

  def load_feed_items
    @feed_items = current_user.feed.includes(:user, :likes, comments: :user).desc.page(params[:page])
      .per Settings.size_page_max_length
  end
end
