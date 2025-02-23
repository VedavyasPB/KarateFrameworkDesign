Feature: Sign Up New User

  Background: Preconditions
    Given url apiUrl
    
  Scenario: New User Sign Up
    Given def userData = 
    """
    {
        email: "sasuke3@gmail.com",
        username: "karateSasuke3"
    }
    """
    Given path 'users'
    And request 
    """
    {
        user:
         {
            email: #('Test'+userData.email),
            password: "Sasuke@47",
            username: #('Test'+userData.username)
         }
    }
    """
    When method post
    Then status 201

