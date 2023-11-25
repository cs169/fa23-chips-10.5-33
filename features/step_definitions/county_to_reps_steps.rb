# frozen_string_literal: true

require 'cucumber/rspec/doubles'

Given(/^I am on the state map page with state symbol "([^"]*)"$/) do |state_symbol|
  visit state_map_path(state_symbol)
end

When(/^I click on a county with state symbol "([^"]*)" and fips code (.*)$/) do |state_symbol, std_fips_code|
  a = { offices:   [{
    name:             'Test Office',
    divisionId:       'ocd-division/country:us',
    official_indices: [0]
  }],
        officials: [{
          name: 'Test Official'
        }] }
  b = a.to_json
  stub_api_resp = JSON.parse(b, object_class: OpenStruct)

  # :google_civics_api
  #   instance_double(Google::Apis::CivicinfoV2::CivicInfoService).tap do |double|
  #     allow(double).to receive(:key=).with(Rails.application.credentials[:GOOGLE_API_KEY])
  #     allow(double).to receive(:representative_info_by_address).and_return(api_response)
  #   end

  allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(@test)
  allow(@test).to receive(:key=)
  allow(@test).to receive(:representative_info_by_address).and_return(stub_api_resp)

  visit county_path(state_symbol, std_fips_code)
end

Then(/^show me the page content$/) do
  puts page.body
end
