# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe 'check mapcontroller methods' do
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

    it 'index' do
      allow(controller).to receive(:index).and_call_original
      get :index
      expect(controller).to have_received(:index)
      expect(assigns(:states)).to match(State.all)
    end

    it 'get valid state' do
      allow(controller).to receive(:state).and_call_original
      get :state, params: { state_symbol: 'CA' }
      expect(controller).to have_received(:state)
      expect(assigns(:state)).to match(State.find_by(symbol: 'CA'))
    end

    it 'get invalid state, return nil' do
      allow(controller).to receive(:state).and_call_original
      get :state, params: { state_symbol: 'abcd' }
      expect(assigns(:state)).to be_nil
      expect(response).to redirect_to('/')
    end

    it 'get valid county' do
      allow(controller).to receive(:county).and_call_original
      get :county, params: { state_symbol: 'CA', std_fips_code: '001' }
      expect(controller).to have_received(:county)
      expect(assigns(:county)).not_to be_nil
      expect(assigns(:representatives)).not_to be_nil
    end

    it 'get invalid county, return nil' do
      allow(controller).to receive(:state).and_call_original
      get :state, params: { state_symbol: 'CA', std_fips_code: '123213' }
      expect(assigns(:state)).not_to be_nil
      expect(assigns(:county)).to be_nil
      expect(response).to redirect_to('/')
    end
  end
end
