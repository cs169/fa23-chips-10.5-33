# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
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
      allow(Representative).to receive(:civic_api_to_representative_params).and_return(true)
    end

    it 'get valid address' do
      allow(controller).to receive(:search).and_call_original
      get :search, params: { address: 'CA' }
      expect(assigns(:representatives)).not_to be_nil
      expect(response.status).to eq(200)
    end
  end
end
