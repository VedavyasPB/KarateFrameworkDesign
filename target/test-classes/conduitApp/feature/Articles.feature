Feature: Articles
  Background: Define URL
    Given url 'https://conduit-api.bondaracademy.com/api/'
    Given path 'users/login'
    And request {user: {email: "karate@test12.com", password: "karate123"}}
    When method post
    Then status 200
    * def token =  response.user.token
    @ignore
  Scenario: Create a new article
    Given header Authorization = 'Token '+ token
    Given path 'articles'
    And request {article: {title: "tester tester", description: "test test", body: "test test", tagList: []}}
    When method post
    Then status 201
    And match response.article.title == 'tester tester'
    @debug
    Scenario: create and delete an article
      * def uniqueTitle = 'Trash-' + karate.timestamp()
      * def requestBody = {"article": {title: uniqueTitle, description: "Trash", body: "Trash", tagList: []}}
  
      Given header Authorization = 'Token ' + token
      Given path 'articles'
      And request requestBody
      When method post
      Then status 201
      Then def articleId = response.article.slug
      And match response.article.title == uniqueTitle
  
      Given params { limit: 10, offset: 0}
      Given path 'articles'
      When method Get
      Then status 200
      And match response.articles contains deep { title: uniqueTitle }
  
      Given header Authorization = 'Token ' + token
      Given path 'articles', articleId
      When method Delete
      Then status 204
  
      Given params {limit: 10 , offset: 0}
      Given path 'articles'
      When method Get
      Then status 200
      And match response.articles !contains { title: uniqueTitle }
  


