# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  describe 'counties' do
    it 'returns http success' do
      get :counties, params: { state_symbol: 'CA' }
      expect(assigns(:state)).to match(State.find_by(symbol: 'CA'))
      expect(response.status).to eq(200)
    end
  end
end
