class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      render json: { status: 'success', current_user: user }
    else
      render json: { status: 'error', message: 'Incorrect password and/or email!' }

    end
  end
end
