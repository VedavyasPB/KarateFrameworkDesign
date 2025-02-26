    @debug
Feature: Tests for the home page
  Background: Define URL
    Given url apiUrl
    
  Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains ['GitHub','Test']
    And match response.tags !contains 'truck'
    And match response.tags contains any ['fish','qa career', 'dog']
    # And match response.tags !contains any ['fish', 'dog']
    # And match response.tags comntains only ['dog']
    And match response.tags == "#array"
    And match each response.tags == "#string"
  
    @skipme
  Scenario: Get 10 articles from the page
    * def timeValidator = read ('classpath:helpers/timeValidator.js')
    Given params {  limit : 10, offset : 0}
    Given path 'articles'
    When method Get
    Then status 200 
    And match response.articles == "#[10]"
    And match response.articlesCount == 10
    And match response.articlesCount != 100
    And match response == {"articles": '#array', "articlesCount": 10}
    And match response.articles[0].createdAt contains '2024'
    And match response.articles[*].favoritesCount contains 18
    And match response.articles[*].author.bio contains null
    And match response..bio contains null
    And match each response..following == false
    And match each response..following == '#boolean'
    And match each response..favoritesCount == '#number'
    And match each response..bio == '##string'
    And match each response.articles ==
    """
      {
        "slug": "#string",
        "title": "#string",
        "description": "#string",
        "body":"#string",
        "tagList": '#array',
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "favorited": '#boolean',
        "favoritesCount": '#number',
        "author": {
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "following": '#boolean'
        }
    }
    """