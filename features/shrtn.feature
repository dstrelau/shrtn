Feature: shrtn the shortener
  In order to run my own URL shortener
  As a geek
  I want a shortener that works

  Scenario: Shorten a URL
    Given 61 URLs have been shortened
    And I am on the homepage
    When I shrtn "http://google.com"
    Then I should see "http://example.org/10"

  Scenario: Retrieve a shortened URL
    Given I have shortened "http://google.com" as "g"
    When I go to "/g"
    Then I should be on "http://google.com"
  