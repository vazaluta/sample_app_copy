class UserMailer < ApplicationMailer

    # actionではなくmethod
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
    # => return: mail object (text/html) 暗黙の戻り値
    #   example: mail.deliver 　好きなタイミングで
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
