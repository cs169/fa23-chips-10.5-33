Feature: County to Representatives

  Scenario: Trying to see my representatives by clicking on my county
    Given I am on the state map page with state symbol "CA"
    When I click on a county with state symbol "CA" and fips code 085
    Then I should see "Test Official"
    Then I should not see "John Thune"
    Then I should not see "Joseph R. Biden"
  
  Scenario: Visiting an invalid state
    Given I am on the state map page with state symbol "CD"
    Then I should see "State 'CD' not found"
    Then I should not see "Joseph R. Biden"
    Then I should not see "Counties in"

  Scenario: Visiting an invalid county
    Given I am on the state map page with state symbol "CA"
    When I click on a county with state symbol "CA" and fips code 1234
    Then I should see "County with code '1234' not found for CA"
    Then I should not see "Representatives in"
    Then I should not see "Joseph R. Biden"
    Then I should not see "Kamala D. Harris"
