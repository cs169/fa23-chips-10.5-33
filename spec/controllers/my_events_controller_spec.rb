# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  describe 'test new' do
    it 'new' do
      get :new
      expect(assigns(:event))
    end
  end

  describe 'test create' do
    it 'create' do
      get :create
      expect(assigns(:event)).to eq(Event.new)
    end
  end

end
