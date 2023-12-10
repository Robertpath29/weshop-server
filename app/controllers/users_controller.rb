# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.new user_params
    if user.save
      confirm_email
      render json: { status: 'success', message: 'User created' }
    else
      render json: { status: 'error', message: user.errors.full_messages.join(', '), warning: user.errors }
    end
  end

  def update
    user = User.find params[:id]
    if user.update user_params
      user = user.attributes.except('password_digest', 'created_at', 'updated_at', 'remember_token_digest')
      render json: { status: 'success', current_user: user }
    else
      render json: { status: 'error', message: user.errors.full_messages.join(', '), warning: user.errors }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :old_password, :last_name,
                                 :date_of_birth, :country, :city, :address)
  end

  def confirm_email
    client = Aws::SES::Client.new
    email_address = params[:user][:email]

    client.verify_email_identity({
                                   email_address:
                                 })
  end
end
