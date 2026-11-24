require 'rails_helper'

RSpec.describe 'RateLimit', type: :request do
  describe 'Registering a new user' do
    it 'limits the number of requests' do
      5.times do
        post user_registration_path,
             params: { user: { email: "test#{SecureRandom.uuid}@account.com", password: 'password',
                               password_confirmation: 'password' } }

        sign_out :user
      end

      post user_registration_path,
           params: { user: { email: "test#{SecureRandom.uuid}@account.com", password: 'password',
                             password_confirmation: 'password' } }
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'Signing in a user' do
    it 'limits the number of requests' do
      user = create(:user, password: 'password')

      5.times do
        post user_session_path,
             params: { user: { email: user.email, password: 'password' } }

        sign_out :user
      end

      post user_session_path,
           params: { user: { email: user.email, password: 'password' } }
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'Resetting a password' do
    it 'limits the number of requests' do
      user = create(:user, password: 'password')

      3.times do
        post user_password_path,
             params: { user: { email: user.email } }

        sign_out :user
      end

      post user_password_path,
           params: { user: { email: user.email } }
      expect(response).to redirect_to(root_url)
      follow_redirect!
      expect(response.body).to include('Too many password reset requests. Please try again later.')
    end
  end
end
