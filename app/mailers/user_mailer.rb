class UserMailer < ApplicationMailer
  def account_activation email
    @email = email
    @greeting = "Hi"
    mail to: @email[:mail], subject: "Account activation"
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
