class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, except: %i(new create index following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.size_page_max_length
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    respond_to do |format|
      if @user.save
        @user.send_activation_email
        format.js
      else
        format.html { render :new }
      end
    end
  end

  def show
    @create_relationship = current_user.active_relationships.build
    @destroy_relationship = current_user.active_relationships.find_by followed_id: @user.id
    @microposts = @user.microposts.includes(:likes, comments: :user).desc
      .page(params[:page]).per Settings.size_page_max_length
    redirect_to(root_url) && return unless @user.activated == true
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update_attributes user_params
        format.html {
          flash[:success] = "Profile updated"
          redirect_to @user
        }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = "Cannot find this user"
    redirect_to root_url
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
