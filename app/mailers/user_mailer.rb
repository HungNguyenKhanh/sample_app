class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail.acc_activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail.pwd_reset.subject")
  end
end
