# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :find_user, only: %i[destroy]

  def create
    if params[:remember_token].present?
      log_in_user_cookie
    else
      log_in_user
    end
  end

  def destroy
    if @user.forget
      render json: { status: 'success', message: 'token delete' }
    else
      render json: { status: 'error', message: @user.errors.full_messages.join(', ') }
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def log_in_user_cookie
    user = User.find_by(id: params[:id])
    if user&.remember_token_authenticated?(params[:remember_token])
      user = user.attributes.except('password_digest', 'created_at', 'updated_at', 'remember_token_digest')
      render json: { status: 'success', current_user: user }
    else
      render json: { status: 'error', message: 'Incorrect remember token!' }
    end
  end

  def log_in_user
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      user.remember
      all_user = user
      user = user.attributes.except('password_digest', 'created_at', 'updated_at', 'remember_token_digest')
      render json: { status: 'success', current_user: user, remember_token: all_user.remember_token_digest }
    else
      render json: { status: 'error', message: 'Incorrect password and/or email!' }

    end
  end
end
