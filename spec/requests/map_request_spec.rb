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

  describe 'GET /state/' do
    it 'returns http success' do
      get '/state/CA'
      expect(response.status).to eq(302)
    end
  end
end
