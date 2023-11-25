# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    # before do
    #   office_info = [Office.new('Berkeley', 'ocd-division/country:us/state:ca', [0])]
    #   official_info = [Official.new('Brandon')]
    #   @rep1_info = RepInfo.new(office_info, official_info)
    #   Representative.civic_api_to_representative_params(@rep1_info)

    let(:rep1_info) do
      OpenStruct.new(
        officials: [OpenStruct.new(name: 'Brandon', ocdid: 'ocd-division/country:us/state:ny', title: 'VP')],
        offices:   [OpenStruct.new(name: 'VP', division_id: 'ocd-division/country:us/state:ny', official_indices: [0])]
      )
    end

    context 'when API returns rep already in the database' do
      let(:exisiting_rep_info) do
        described_class.create!(
          name: 'Brandon', ocdid: 'ocd-division/country:us/state:ny', title: 'President'
        )
      end

      before do
        described_class.civic_api_to_representative_params(rep1_info)
        exisiting_rep_info.reload
      end

      it 'does not create a new rep' do
        # call method & expect no new rep to be created

        expect(lambda {
                 described_class.civic_api_to_representative_params(rep1_info)
               }).not_to change(described_class, :count)
      end

      it 'updates the rep title to President' do
        expect(exisiting_rep_info.title).to eq('President')
      end
    end

    context 'when API returns a new rep' do
      it 'creates a new rep in the database' do
        # office_info = [Office.new('Berkeley', 'ocd-division/country:us/state:ca', [0])]
        # official_info = [Official.new('Anusha')]
        # rep2_info = RepInfo.new(office_info, official_info)

        expect(lambda {
                 described_class.civic_api_to_representative_params(rep1_info)
               }).to change(described_class, :count).by(1)
      end
    end
  end
end
