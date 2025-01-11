@natived-test2
Feature: Test on the Globalmantics Categories API
  Background:
#    * url 'http://localhost:8080/api/' - moved this to a variable in the config file
#    * url apiUrl
#
#    Given path 'authenticate' - moved this out to a separate feature file
#    And request '{"username":"admin", "password":"admin"}'
#    And header Content-Type = 'application/json'
#    When method post
#    Then status 200

#    * def token = response.token
#    * print 'Value of token: ' + token

    * url apiUrl

    #    * def tokenResponse = call read('classpath:helpers/CreateAuthToken.feature') - this creates token for every scenario call
    # this calls the token only once for all scenarios in this feature file
#    * def tokenResponse = callonce read('classpath:helpers/CreateAuthToken.feature') - we moved this into the cofig file
#
#
#    * def token = tokenResponse.token

  @natived-test1 @stable
  Scenario: Get all categories
    Given path 'category'
    When method Get
    Then status 200

  Scenario: Create a Category
    Given path 'category'
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And request '{"name": "My new category"}'
    When method Post
    Then status 200

  Scenario: Create and get Category
    * def categoryName = 'New Toys'

    Given path 'category'
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And request '{"name": "' + categoryName + '"}'
    When method Post
    Then status 200
    And match response.name == categoryName
    * def categoryId = response.id