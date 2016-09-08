Feature: Signing In
  Scenario: Unsuccessfull signin
    Given a user visits the signin page
    When they submit invalid signin information
    Then they should see an error message

  Scenario: Successful signin
    Given a user visits the signin page
    And the user has an account
    When the user submit valid signin information
    Then they should see their profile page
    And they should see a singout link
