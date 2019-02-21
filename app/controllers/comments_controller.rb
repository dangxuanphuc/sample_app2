class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :find_micropost, only: %i(index new create edit update destroy)
  before_action :find_comment, only: %i(edit update destroy)

  def index
    @comments = @micropost.comments.offset(params[:offset].to_i).limit(2)    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @micropost.comments.build comment_params
    @comment.user_id = current_user.id

    respond_to do |format|
      format.js do
        @comment.save if @comment.valid?
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
      if @comment.update_attributes comment_params
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit :content
  end

  def find_micropost
    @micropost = Micropost.find_by id: params[:micropost_id]

    return if @micropost
    flash[:danger] = "Micropost not found!"
    redirect_to root_path
  end

  def find_comment
    @comment = @micropost.comments.find_by id: params[:id]

    return if @comment
    flash[:danger] = "Comment not found!"
    redirect_to @micropost
  end
end
