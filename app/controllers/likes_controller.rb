class LikesController < ApplicationController
  before_action :find_micropost
  before_action :find_like, only: %i(destroy)

  def create
    respond_to do |format|
      if already_liked?
        format.html {
          flash[:danger] = "You can't like more than once"
          redirect_to root_path
        }
      else
        @like = @micropost.likes.build user_id: current_user.id

        if @like.save
          format.js
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if !(already_liked?)
        format.html {
          flash.now[:danger] = "Cannot unlike"
          redirect_to root_path
        }
      else
        if @like.destroy
          format.js
        end
      end
    end
  end

  private

  def find_micropost
    @micropost = Micropost.find_by id: params[:micropost_id]

    return if @micropost
    flash[:danger] = "Micropost not found!"
    redirect_to root_path
  end

  def find_like
    @like = @micropost.likes.find_by id: params[:id]
  end

  def already_liked?
    Like.where(user_id: current_user.id, micropost_id:
      params[:micropost_id]).exists?
  end
end
