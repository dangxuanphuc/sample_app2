class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    respond_to do |format|
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        format.js
        redirect_to root_url
      else
        format.js
      end
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, "can't be empty"
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = "Cannot find this user"
    redirect_to root_url
  end

  def valid_user
    unless @user&.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
