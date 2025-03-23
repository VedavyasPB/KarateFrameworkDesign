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
    # @debug
  Scenario: Conditional logic
    Given params {  limit : 10, offset : 0}
    Given path 'articles'
    When method Get
    Then status 200 
    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]

    # * if(favoritesCount==0) karate.call('classpath:helpers/AddLikes.feature', article)

    * def result = favoritesCount == 0? karate.call('classpath:helpers/AddLikes.feature', article):favoritesCount

    Given params {  limit : 10, offset : 0}
    Given path 'articles'
    When method Get
    Then status 200 
    And match response.articles[0].favoritesCount == result

    
  Scenario: Retry call
    * configure retry = {count:10,interval:5000}
    Given params {  limit : 10, offset : 0}
    Given path 'articles'
    And retry until response.articles[0].favoritesCount == 1
    When method Get
    Then status 200 
    
  Scenario: Sleep call
    * def sleep = function(pause){ java.lang.Thread.sleep(pause)}
    Given params {  limit : 10, offset : 0}
    Given path 'articles'
    When method Get
    * eval sleep(5000)
    Then status 200 

    # Type Conversion
  
  Scenario: Number to string
    * def foo = 10
    * def json = {"bar": #(foo+'')}
    * match json == {'bar': '10'}
    @debug
  Scenario: String to Number
    * def foo = '10'
    * def json = {"bar": #(foo*1)}
    # ~~ used to convert double type to integer
    * def json2 = {"bar": #(~~parseInt(foo))} 
    * match json == {'bar': 10}
    * match json2 == {'bar': 10}