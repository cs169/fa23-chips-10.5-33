# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  describe 'test new' do
    it 'new' do
      get 'new', params: { representative_id: 0 }
      expect(assigns(:news_item)).to be_nil
    end
  end
end
