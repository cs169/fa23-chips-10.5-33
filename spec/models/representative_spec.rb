require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    before do
      office_info = [Office.new('Berkeley', 'ocd-division/country:us/state:ca', [0])]
      official_info = [Official.new('Brandon')]
      @rep1_info = RepInfo.new(office_info, official_info)
      Representative.civic_api_to_representative_params(@rep1_info)
    end

    context 'when API returns rep already in the database' do
      it 'does not create a new rep' do
        # call method & expect no new rep to be created
        expect (Representative.civic_api_to_representative_params(@rep1_info)).not_to change(Representative, :count)
      end
    end

    context 'when API returns a new rep' do
      it 'creates a new rep in the database' do 
        office_info = [Office.new('Berkeley', 'ocd-division/country:us/state:ca', [0])]
        official_info = [Official.new('Anusha')]
        rep2_info = RepInfo.new(office_info, official_info)
        
        expect (Representative.civic_api_to_representative_params(rep2_info)).to change(Representative, :count).by(1)
      end
    end
  end
end


end
