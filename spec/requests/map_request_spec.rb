# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Map request', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response.status).to eq(200)
    end

    it 'response renders map/index template' do
      get '/'
      expect(response).to render_template('map/index')
    end
  end

  describe 'GET /state/CA' do
    it 'returns http success' do
      get '/state/CA'
      expect(response).to render_template('map/state')
      expect(@state).should_not be_nil
      expect(@county_detail).should_not be_nil
    end

    it 'returns alert when invalid state' do
      get '/state/abc'
      expect(response).to redirect_to('/')
      @state.should be_nil
      @county_details.should be_nil
    end
  end

  describe 'GET /state/CA/county/001' do
    it 'returns http success' do
      get '/state/CA/county/001'
      expect(response).to render_template('map/county')
      expect(@county_details).should_not be_nil
      expect(@address).should_not be_nil
      expect(@representatives).should_not be_nil
    end

    # it 'returns alert when invalid county' do
    #   get '/state/CA/county/123'
    #   expect(response).to redirect_to('/')
    #   expect(@state).should_not be_nil
    #   @county.should be_nil
    # end
  end
end
