Feature: Articles

  Background: Define URL
    Given url apiUrl

    #   @ignore
    # Scenario: Create a new article
    #   Given path 'articles'
    #   And request {article: {title: "tester tester", description: "test test", body: "test test", tagList: []}}
    #   When method post
    #   Then status 201
    #   And match response.article.title == 'tester tester'
    # @debug
    Scenario: create and delete an article
      Given path 'articles'
      And request {article: {title: "api tester bro", description: "api tester bro", body: "api tester bro", tagList: []}}
      When method post
      Then status 201
      * def articleId = response.article.slug

      Given params { limit: 10, offset: 0}
      Given path 'articles'
      When method Get
      Then status 200
      And match response.articles[0].title == 'api tester bro'

      Given path 'articles',articleId
      When method Delete
      Then status 204

      Given params {limit: 10 , offset: 0}
      Given path 'articles'
      When method Get
      Then status 200
      And match response.articles[0].title != 'api tester bro'


