
Feature: Home Work

    Background: Preconditions
        * url apiUrl 
        Given def timeValidator = read ('classpath:helpers/timeValidator.js')
        
    
    Scenario: Favorite articles
        Given params {  limit : 10, offset : 0}
        Given path 'articles'
        When method get
        Then status 200
        * def slugId = response.articles[0].slug
        * def favoritesCount = response.articles[0].favoritesCount
        * def initialCount = response.articles[0].favoritesCount

        Given path 'articles',slugId,'favorite'
        Given request {}
        When method post
        Then status 200
        And match response == 
        """
            {
                "article": {
                    "id": '#number',
                    "slug": '#string',
                    "title": '#string',
                    "description": '#string',
                    "body": '#string',
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "authorId": '#number',
                    "tagList": '#array',
                    "author": {
                        "username": '#string',
                        "bio": '##string',
                        "image": '#string',
                        "following": '#boolean'
                    },
                    "favoritedBy": [
                        {
                            "id": '#number',
                            "email": '#string',
                            "username": '#string',
                            "password": '#string',
                            "image": '#string',
                            "bio": '##string',
                            "demo": '#boolean'
                        }
                    ],
                    "favorited": '#boolean',
                    "favoritesCount": '#number'
                }
            }
        """
            * if(initialCount==0) response.article.favoritesCount == initialCount + 1
            * if(initialCount==1) response.article.favoritesCount == initialCount - 1

            Given params {  limit : 10, offset : 0}
            Given path 'articles'
            When method get
            Then status 200
            * match each response.articles[*] == 
            """
                        {
                            "slug": "#string",
                            "title": "#string",
                            "description": "#string",
                            "body": "#string",
                            "tagList": "#array",
                            "createdAt": "#? timeValidator(_)",
                            "updatedAt": "#? timeValidator(_)",
                            "favorited": "#boolean",
                            "favoritesCount": "#number",
                            "author": {
                                "username": "#string",
                                "bio": "##string",
                                "image": "#string",
                                "following": "#boolean"
                            }
                        }
            """
            * match response.articlesCount == '#number' 
            * def slugId2 = response.articles[0].slug
            * match slugId2 == slugId
    Scenario: Comment articles

        Given params {  limit : 10, offset : 0}
        Given path 'articles'
        When method get
        Then status 200
        * def slugId = response.articles[0].slug
    # Validating comments schema
        Given path 'articles',slugId,'comments'
        When method get
        Then status 200
        Then match each response.comments[*] == 
        """
                {
                    "id": '#number',
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "body": '#string',
                    "author": {
                        "username": '#string',
                        "bio": '##string',
                        "image": '#string',
                        "following": '#boolean'
                    }
                }
        """
         * def responseWithComments = response.comments
         * def articlesCount = responseWithComments.length
    # Adding a new comment
         Given path 'articles',slugId,'comments'
         * def newComment = 'fresh'
         * request {comment: {body: #(newComment)}}
         When method post
         Then status 200
         Then match response.comment.body == newComment
    # Checking comments count after adding a comment
        Given path 'articles',slugId,'comments'
        When method get
        Then status 200
        * def newResponseWithComments = response.comments
        * def Id = response.comments[0].id
        * def newArticlesCount = newResponseWithComments.length
        * match newArticlesCount == articlesCount + 1
    #  Deleting a comment
        Given path 'articles',slugId,'comments',Id
        When method delete
        Then status 200
    #  Verifying comments count again after deleting the comment
        Given path 'articles',slugId,'comments'
        When method get
        Then status 200
        * def afterDeletionResponseWithComments = response.comments
        * def AfterDeletionArticleCount = afterDeletionResponseWithComments.length
        * match AfterDeletionArticleCount == articlesCount