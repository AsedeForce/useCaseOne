@isTest
public with sharing class MovieTriggerTest {
    @TestSetup
    static void dataSetup() {
      Movie__c movie1 = (Movie__c) TestDataFactory.createSObject(
        'Movie__c',
        new Map<String, Object>{ 'Name' => 'Titanic' }
      );
  
      Movie__c movie2 = (Movie__c) TestDataFactory.createSObject(
        'Movie__c',
        new Map<String, Object>{ 'Name' => 'Transporter' }
      );
  
      Actor__c actor1 = (Actor__c) TestDataFactory.createSObject(
        'Actor__c',
        new Map<String, Object>{
          'Name' => 'Leonardo DiCaprio',
          'Gender__c' => 'Male'
        }
      );
  
      Actor__c actor2 = (Actor__c) TestDataFactory.createSObject(
        'Actor__c',
        new Map<String, Object>{
          'Name' => 'Jennifer Lawrence',
          'Gender__c' => 'Female'
        }
      );

      Actor__c actor3 = (Actor__c) TestDataFactory.createSObject(
        'Actor__c',
        new Map<String, Object>{
          'Name' => 'test female',
          'Gender__c' => 'Female'
        }
      );

      Actor__c actor4 = (Actor__c) TestDataFactory.createSObject(
        'Actor__c',
        new Map<String, Object>{
          'Name' => 'test male',
          'Gender__c' => 'Male'
        }
      );
  
      MovieActor__c movieActor1 = (MovieActor__c) TestDataFactory.createSObject(
        'MovieActor__c',
        new Map<String, Object>{
          'Movie__c' => movie1.Id,
          'Actor__c' => actor1.Id
        }
      );

      MovieActor__c movieActor4 = (MovieActor__c) TestDataFactory.createSObject(
        'MovieActor__c',
        new Map<String, Object>{
          'Movie__c' => movie1.Id,
          'Actor__c' => actor3.Id
        }
      );
  
      MovieActor__c movieActor3 = (MovieActor__c) TestDataFactory.createSObject(
        'MovieActor__c',
        new Map<String, Object>{
          'Movie__c' => movie2.Id,
          'Actor__c' => actor2.Id
        }
      );

      MovieActor__c movieActor2 = (MovieActor__c) TestDataFactory.createSObject(
        'MovieActor__c',
        new Map<String, Object>{
          'Movie__c' => movie2.Id,
          'Actor__c' => actor4.Id
        }
      );
    }
  
    @IsTest
    static void afterInsertTest() {
      
      Movie__c movie =[ select Id, Name from Movie__c WHERE Name = 'Transporter'];
      Actor__c actor = [ select Id, Name from Actor__c where Name = 'Leonardo DiCaprio'];
  
      movie = [ select Id, Name, MaleActorsPercentage__c, FemaleActorsPercentage__c from Movie__c WHERE Name = 'Transporter'];
      actor = [ select Id, Name, Number_of_movies__c from Actor__c where Name = 'Leonardo DiCaprio'];

      System.assertEquals(1, actor.Number_of_movies__c);
      System.assertEquals((100.00 / 2), movie.MaleActorsPercentage__c);
      System.assertEquals((100.00 / 2), movie.FemaleActorsPercentage__c);
    }
  
    @IsTest
    static void afterDeleteTest() {
  
      Actor__c actor = [ select Id, Name from Actor__c where Name = 'Leonardo DiCaprio'];
      MovieActor__c movieActor = [
        SELECT Id
        FROM MovieActor__c
        WHERE Actor__c = :actor.Id
        LIMIT 1
      ];

      Test.startTest();
      Database.DeleteResult result3 = Database.delete(movieActor, false);
      Test.stopTest();
  
      actor = [ select Id, Name, Number_of_movies__c from Actor__c where Name = 'Leonardo DiCaprio'];
      Movie__c movie = [ select Id, Name, FemaleActorsPercentage__c, MaleActorsPercentage__c from Movie__c WHERE Name = 'Titanic'];
      System.assertEquals(0, actor.Number_of_movies__c);
      System.assertEquals(0, movie.MaleActorsPercentage__c);
      System.assertEquals(100, movie.FemaleActorsPercentage__c);
    }
}