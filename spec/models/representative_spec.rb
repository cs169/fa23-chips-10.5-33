
require 'rails_helper'

#Write characterization tests:
# api returns no officials, return empty arr
# api returns official already in database, should not create duplicate official
# api returns new officials, creates officials in database

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do

    #before all create rep for testing

    context 'when API returns rep already in database' do
      it 'does not create new rep' do
        
        # create another double rep already in databse ?

        #call method & expect no new rep to be created
        expect {Representative.civic_api_to_representative_params(#name of the created rep)}.not_to change(Representative, :count)
      end
    end

    context 'when API returns new rep' do
      it 'creates a new rep in database' do 
        expect {Representative.civic_api_to_representative_params(#name of created rep)}.to change(Representative, :count).by(1)
      end
    end
  end
end


