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
end
