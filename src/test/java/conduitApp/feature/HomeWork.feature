
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
        @debug
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


        # Step 1: Get atricles of the global feed
        # Step 2: Get the slug ID for the first arice, save it to variable
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        # Step 11: Get all comments again and verify number of comments decreased by 1