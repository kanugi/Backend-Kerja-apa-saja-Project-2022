class PasswordMailer < ActionMailer::Base
  default :from => "kanikayudha.17@students.amikom.ac.id"

  def reset_password(user)
    @user = user
    @url =  ENV["FRONTEND_URL"]  + "reset_password/?token=" + @user.reset_password_token 
    mail(to: @user.email, subject: "Reset Password")
  end
end
