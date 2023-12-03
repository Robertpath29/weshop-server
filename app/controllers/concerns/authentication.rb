# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern
  # rubocop:disable Metrics/BlockLength
  included do
    private

    def log_in
      current_user = if params[:email].present?
                       User.find_by(email: params[:email].downcase)
                     else
                       User.find_by(id: params[:id])
                     end
      if params[:remember_token].present?
        log_in_token(current_user)
      else
        log_in_password(current_user)
      end
    end

    def log_in_password(user)
      if user&.authenticate(params[:password])
        user.remember
        all_user = user
        user = user.attributes.except('password_digest', 'created_at', 'updated_at', 'remember_token_digest')
        render json: { status: 'success', current_user: user, remember_token: all_user.remember_token_digest }
      else
        render json: { status: 'error', message: 'Incorrect password and/or email!' }

      end
    end

    def log_in_token(user)
      if user&.remember_token_authenticated?(params[:remember_token])
        user = user.attributes.except('password_digest', 'created_at', 'updated_at', 'remember_token_digest')
        render json: { status: 'success', current_user: user }
      else
        render json: { status: 'error', message: 'Incorrect remember token!' }
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
