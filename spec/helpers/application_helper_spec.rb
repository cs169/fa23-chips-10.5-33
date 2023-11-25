# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'state methods' do
    it 'state_ids_by_name' do
      expect(described_class.state_ids_by_name.length).to eq(56)
    end

    it 'state_symbols_by_name' do
      expect(described_class.state_symbols_by_name.length).to eq(56)
    end
  end

  it 'nav_items' do
    expect(described_class.nav_items).not_to be_nil
  end
end
