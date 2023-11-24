# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'after successful login' do
    before do
      user = User.create(
        uid:        123,
        provider:   User.providers[:google_oauth2],
        first_name: 'TestF',
        last_name:  'TestL',
        email:      'TestE'
      )
      session[:current_user_id] = user.id
    end

    it 'login again' do
      get :login
      expect(response).to redirect_to('/user/profile')
    end

    it 'logout' do
      get :logout
      expect(session[:current_user_id]).to be_nil
    end
  end
end
