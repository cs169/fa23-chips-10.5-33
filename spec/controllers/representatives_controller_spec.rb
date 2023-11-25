# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'index' do
    it 'sets all representatives when index' do
      get :index
      expect(assigns(:representatives)).to eq(Representative.all)
    end
  end
end
