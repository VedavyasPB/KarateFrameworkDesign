Feature: Dummy

  Scenario: Dummy
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def username = DataGenerator.getRandomUserName()
    * print username
