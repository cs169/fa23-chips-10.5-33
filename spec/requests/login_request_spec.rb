# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'login request', type: :request do
  describe '/login' do
    before do
      get '/login'
    end

    it 'returns success response' do
      expect(response.status).to eq(200)
    end

    it 'includes github button' do
      expect(response.body).to include('Sign in with GitHub')
    end

    it 'includes google button' do
      expect(response.body).to include('Sign in with Google')
    end
  end

  describe 'after successful load' do
    before do
      get '/login'
    end

    it 'tries to use google auth' do
      post '/auth/google_oauth2',
           params: { name:               '&#x2713;',
                     authenticity_token: '' }
      expect(response).to redirect_to('/auth/google_oauth2/callback')
    end

    it 'tries to use github auth' do
      post '/auth/github',
           params: { name:               '&#x2713;',
                     authenticity_token: '' }
      expect(response).to redirect_to('/auth/github/callback')
    end
  end

  describe 'after successful login' do
    before do
      User.create(
        uid:        123,
        provider:   User.providers[:google_oauth2],
        first_name: 'TestF',
        last_name:  'TestL',
        email:      'TestE'
      )
      get '/'
    end

    it 'login again' do
      get '/login'
    end

    it 'logout' do
      get '/logout'
      expect(response).to redirect_to('/')
    end
  end
end
