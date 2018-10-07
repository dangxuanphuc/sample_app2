class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @greeting = "Hi"
    mail to: user.email, subject: "Account activation"
  end
end
