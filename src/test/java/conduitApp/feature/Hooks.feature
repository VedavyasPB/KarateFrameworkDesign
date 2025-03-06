    @debug
Feature: Hooks   

  Background: hooks
    # * def result = callonce read('classpath:helpers/Dummy.feature')
    # * def username = result.username

    * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature')}
    * configure afterFeature = 
    """
    function(){
        karate.log('After feature text')
    }
    """

  Scenario: First Scenario
    * print 'This is the first scenario'
  Scenario: Second Scenario
    * print 'This is the second scenario'
