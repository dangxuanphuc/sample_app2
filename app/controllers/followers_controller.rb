class FollowersController < ApplicationController
  attr_reader :user

  before_action :logged_in_user, only: %i(index)
  before_action :find_user, only: %i(index)

  def index
    @title = "Followers"
    @users = @user.followers.page(params[:page])
      .per Settings.size_page_max_length
    render "users/show_follow"
  end

  private
  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = :user_not_found
    redirect_to root_url
  end
end
