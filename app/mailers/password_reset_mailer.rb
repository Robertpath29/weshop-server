# frozen_string_literal: true

class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    mail to: @user.email, subject: 'Query for change password'
  end
end
