Feature: Test on the Globalmantics Products API
  Background:
    #    * url 'http://localhost:8080/api/'
#    * url apiUrl
#
#    Given path 'authenticate'
#    And request '{"username":"admin", "password":"admin"}'
#    And header Content-Type = 'application/json'
#    When method post
#    Then status 200
#
#    * def token = response.token
#    * print 'Value of token: ' + token

#    * def tokenResponse = call read('classpath:helpers/CreateAuthToken.feature')
#    * def tokenResponse = callonce read('classpath:helpers/CreateAuthToken.feature') moved this into the config file
#
#    * def token = tokenResponse.token

    * url apiUrl
    * def productRequestBody = read('classpath:globalmantics/data/newProduct.json')



  Scenario: Get all produts
    Given path 'product'
    When method Get
    Then status 200

#    using fuzzy matching
    And match response[0].name == 'Vintage Minature Car'
#    this checks to see if name is a string value
    And match response[0].name == '#string'
#    this checks to see if attribute name is a string throughout the JSON - meaning it could be nested
    And match each response..name == '#string'
#    this checks to see if a field has a string value in it
    And match response[0].createdAt contains '2020'
#    sometimes a field may or may not appear - this allows us to do a check in that situation
    And match response[0].rating == '##number'

  Scenario: Create and Delete product
    * def productName = 'Fast train'
    * set productRequestBody.name = productName

    # Create product
    Given path 'product'
#    And header Authorization = 'Bearer ' + token this is being done in the config file
    And header Content-Type = 'application/json'
    And request productRequestBody
    When method post
    Then status 200
    And match response.name == productName
    * def productId = response.id

    #Get Single product.
    Given path 'product', productId
    When method Get
    Then status 200
    And match response.id == productId
    And match response.name == productName

    # Delete product
    Given path 'product', productId
#    And header Authorization = 'Bearer ' + token this is being done in the config file
    And header Content-Type = 'application/json'
    When method Delete
    Then status 200
    And match response == 'Product: '+ productName +  ' deleted successfully'

  Scenario: Update product
    * def updatedProductName = "Updated Fast Train"
    * def updatedProductJSON =
      """
      {
        "name": #(updatedProductName),
        "description": "A toy train with 3 carriages",
        "price": "19.99",
        "categoryId": 1,
        "inStock": true
      }
      """

    Given path 'product', 5
#    And header Authorization = 'Bearer ' + token this is being done in the config file
    And header Content-Type = 'application/json'
    And request updatedProductJSON
    When method Put
    Then status 200
    And match response.name == updatedProductName

  Scenario: Query paramters
    * def categoryId = '1'

    Given path 'product'
    And param category = categoryId
    When method Get
    Then status 200
    And match each response contains {"categoryId": '1'}
    And match each response contains {"categoryId": #(categoryId) }
    And match each response..categoryId == categoryId

