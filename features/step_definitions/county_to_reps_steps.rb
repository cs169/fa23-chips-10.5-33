# frozen_string_literal: true

Given(/^I am on the state map page with state symbol "([^"]*)"$/) do |state_symbol|
  visit state_map_path(state_symbol)
end

When(/^I click on a county with state symbol "([^"]*)" and fips code (.*)$/) do |state_symbol, std_fips_code|
  visit county_path(state_symbol, std_fips_code)
end

Then(/^show me the page content$/) do
  puts page.body
end
