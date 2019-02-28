class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    respond_to do |format|
      if @user&.authenticate(params[:session][:password])
        if @user.activated?
          log_in @user
          remember_user
          format.html { redirect_back_or @user }
        else
          message = "Account not activated. Check your email for the
            activation link."
          format.html {
            flash[:warning] = message
            redirect_to root_url
          }
        end
      else
        format.js
      end
    end
  end

  def destroy
    log_out if logged_in?
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  def remember_user
    params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
  end
end
