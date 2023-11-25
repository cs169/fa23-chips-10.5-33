# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'profile' do
    before do
      request.env['REQUEST_URI'] = '/'
      @user = User.create(uid:        1,
                          provider:   User.providers[:google_oauth2],
                          first_name: 'TestF',
                          last_name:  'TestL',
                          email:      'TestE')
    end

    it 'sets user when in db' do
      get :profile, session: { current_user_id: 1 }
      expect(assigns(:current_user)).to eq(@user)
    end

    it 'redirect to login when not in db' do
      get :profile, session: { current_user_id: 2 }
      expect(response).to redirect_to('/login')
    end
  end
end
