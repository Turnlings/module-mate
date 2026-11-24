require 'rails_helper'

RSpec.describe 'Users::OmniauthCallbacks', type: :request do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'newuser@example.com',
        name: 'Test User'
      }
    )
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  describe 'POST /users/auth/google_oauth2' do
    it 'creates a confirmed user without sending a confirmation email' do
      expect do
        post user_google_oauth2_omniauth_authorize_path
        follow_redirect!
      end.to change(User, :count).by(1)
                                 .and not_change(ActionMailer::Base.deliveries, :count)

      user = User.last
      expect(user.email).to eq('newuser@example.com')
      expect(user).to be_confirmed
      expect(response).to redirect_to(root_path)
    end
  end
end
