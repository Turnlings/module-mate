# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    rate_limit to: 5, within: 10.minutes, only: :create,
               with: lambda {
                 reset_session
                 render json: { error: 'Too many sign in attempts, please try again later' }, status: :too_many_requests
               }

    rate_limit to: 10, within: 1.hour, only: :destroy

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
