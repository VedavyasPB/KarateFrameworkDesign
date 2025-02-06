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