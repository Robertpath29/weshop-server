class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def create
    @user = User.find_by email: params[:email].downcase
    if @user.present?
      @user.set_password_reset_token
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
      render json: { status: 'success', message: 'instructions were sent to the specified email' }
    else
      render json: { status: 'error', message: 'User with this email address was not found' }
    end
  end

  def update
    if @user.update user_params
      render json: { status: 'success', message: 'password changed' }
    else
      render json: { status: 'error', message: @user.errors.full_messages.join(', '), warning: @user.errors }
    end
  end

  private

  def user_params
    params.require(:user).permit(:password,
                                 :password_confirmation).merge(admin_edit: true)
  end

  def set_user
    @user = User.find_by email: params[:email],
                         password_reset_token: params[:password_reset_token]
    return if @user&.password_reset_period_valid?

    render json: { status: 'error', message: 'The time to change your password has expired!' }
  end
end
