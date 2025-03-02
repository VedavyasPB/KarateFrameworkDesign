    
Feature: Sign Up New User

  Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given url apiUrl
    
  Scenario: New User Sign Up
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUserName = dataGenerator.getRandomUserName()
    * def jsFunction = 
    """
    function(){
      var DataGenerator = Java.type('helpers.DataGenerator')
      var generator = new DataGenerator()
      return DataGenerator.getRandomUserName2()
    }
    """
    * def randomUserName2 = call jsFunction
    Given path 'users'
    And request 
    """
    {
        user:
         {
            email: #(randomEmail),
            password: "Sasuke@47",
            username: #(randomUserName2)
         }
    }
    """
    * print 'Random mail', randomEmail, 'Random user name', randomUserName2
    When method post
    Then status 201
    Then match response == 
    """
      {
        "user": {
            "id": '#number',
            "email": #(randomEmail),
            "username": #(randomUserName2),
            "bio": '##string',
            "image": "#string",
            "token": "#string"
        }
    }
    """
    # @debug
    Scenario Outline: Validate sign up error messages
              * def randomEmail = dataGenerator.getRandomEmail()
              * def randomUserName = dataGenerator.getRandomUserName()
              Given path 'users'
              And request 
              """
              {
                  user:
                   {
                      email: "<email>",
                      password: "<password>",
                      username: "<username>"
                   }
              }
              """
              When method post
              Then status <statusCode>
              And match response == <errorResponse>

              Examples:
              | email | password | username | errorResponse | statusCode |
              | #(randomEmail) | Karate123 | KarateUser123 | {"errors":{"username":["has already been taken"]}} | 422 |
      | KarateUser1@test.com| Karate123 | #(randomUserName) | {"errors":{"email":["has already been taken"]}} | 422 |

