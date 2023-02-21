@isTest
public with sharing class ActorServiceTest {
    @isTest
    public static void testgetActors(){
        List<Actor__c> actors = (List<Actor__c>) TestDataFactory.createSObjectList(
            'Actor__c',
            10
          );
        List<Actor__c> actorsFromService = ActorService.getActors();
        System.assertEquals(10, actorsFromService.size(), 'should be 10');

    }
}