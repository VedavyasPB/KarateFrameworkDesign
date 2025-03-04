
Feature: Home Work

    Background: Preconditions
        * url apiUrl 
        
    @debug
    Scenario: Favorite articles
        Given def timeValidator = read ('classpath:helpers/timeValidator.js')
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
        # Step 1: Get atricles of the global feed
        # Step 2: Get the slug ID for the first arice, save it to variable
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
            * def responseWithComments = [{"article": "first"}, {article: "second"}]
            * def articlesCount = responseWithComments.length
        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        # Step 11: Get all comments again and verify number of comments decreased by 1