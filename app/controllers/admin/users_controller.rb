# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :admin?
    def index
      users = User.pluck(:id, :name, :email, :created_at, :role)
      users = users.map do |user|
        { id: user[0], name: user[1], email: user[2], created_at: User.find(user[0]).formatted_created_at,
          role: user[4] }
      end
      render json: { status: 'success', oll_users: users }
    end

    def update
      user = User.find params[:id]
      if user.update user_params
        render json: { status: 'success', message: 'user role is change' }
      else
        render json: { status: 'error', message: user.errors.full_messages.join(', ') }
      end
    end

    private

    def user_params
      params.require(:user).permit(:role)
    end

    def admin?
      user = User.find_by email: params[:email]
      if user.present?
        render json: { status: 'error', message: 'user is not admin' } if user.role != 'admin'
      else
        render json: { status: 'error', message: 'user not found!' }
      end
    end
  end
end
