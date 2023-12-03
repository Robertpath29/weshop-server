# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :find_user, only: %i[destroy]

  def create
    log_in
  end

  def destroy
    if @current_user.forget
      render json: { status: 'success', message: 'token delete' }
    else
      render json: { status: 'error', message: @current_user.errors.full_messages.join(', ') }
    end
  end

  private

  def find_user
    @current_user = User.find_by(id: params[:id])
  end
end
