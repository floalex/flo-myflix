# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class AppMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/app_mailer/password_reset
  def password_reset
    user = User.first
    AppMailer.send_forgot_password(user)
  end
  
  def invitation_email
    invitation = Invitation.create(recipient_name: "Joe Smith", recipient_email: "joesmith@example.com", message: "Join MyFlix")
    invitation.inviter = User.first
    AppMailer.send_invitation_email(invitation)
  end
end