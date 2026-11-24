# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    rate_limit to: 3, within: 1.hour, only: :create, action: :create_password_reset,
               with: lambda {
                 reset_session
                 redirect_to root_url, alert: 'Too many password reset requests. Please try again later.'
               }

    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    # def create
    #   super
    # end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    # def update
    #   super
    # end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
