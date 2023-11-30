# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :find_user, only: %i[destroy]
  before_action :require_authentication, only: %i[destroy]

  def create
    log_in
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
end
