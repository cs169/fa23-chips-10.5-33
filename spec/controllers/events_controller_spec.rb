# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'test index' do
    it 'no filter' do
      get 'index'
      expect(assigns(:events)).to eq(Event.all)
    end

    it 'filter, county' do
      get 'index', params: { 'filter-by': 0, state: 'CA' }
      state = State.find_by(symbol: 'CA')
      expect(assigns(:events)).not_to eq(Event.where(county: state.counties))
    end

    it 'filter, state only' do
      get 'index', params: { 'filter-by': 'state-only', state: 'CA' }
      state = State.find_by(symbol: 'CA')
      expect(assigns(:events)).to eq(Event.where(county: state.counties))
    end
  end

  describe 'test show' do
    it 'show' do
      get 'show', params: { id: 1 }
      expect(assigns(:event)).to eq(Event.find(1))
    end
  end
end
