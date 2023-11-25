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
    end

    it 'returns alert when invalid state' do
      get '/state/abc'
      expect(response).to redirect_to('/')
    end
  end

  describe 'mock api' do
    let(:api_response) do
      { offices:   [{
        name:             'Test Office',
        divisionId:       'ocd-division/country:us',
        official_indices: [0]
      }],
        officials: [{
          name: 'Test Official'
        }] }
    end

    let(:google_civics_api) do
      instance_double(Google::Apis::CivicinfoV2::CivicInfoService).tap do |double|
        allow(double).to receive(:key=).with(Rails.application.credentials[:GOOGLE_API_KEY])
        allow(double).to receive(:representative_info_by_address).and_return(api_response)
      end
    end

    before do
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(google_civics_api)
      allow(Representative).to receive(:civic_api_to_representative_params).and_return(Representative.all)
    end

    it 'returns http success' do
      get '/state/CA/county/001'
      expect(response).to render_template('map/county')
    end
  end

  describe 'GET /state/CA/county/001' do
    it 'returns alert when invalid county' do
      get '/state/CA/county/123'
      expect(response).to redirect_to('/')
    end
  end
end
